import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:snake_app/core/constants/app_constants.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/shared/widgets/share_score_card.dart';

/// Result of a share / save attempt after the preview step.
enum ShareScoreOutcome {
  /// Preview dismissed without sharing.
  cancelled,

  /// Native share sheet completed or was dismissed by the user.
  shared,

  /// PNG written to disk and revealed (desktop fallback, esp. Linux).
  savedToDisk,

  /// Native share and disk fallback both failed.
  failed,
}

/// Captures a visible [ShareScoreCard] to PNG and shares or saves it.
///
/// Platform notes:
/// - **Android / iOS / macOS / Windows / Web:** system share sheet via `share_plus`
/// - **Linux:** file share is unsupported by `share_plus` → save + open folder
/// - After adding `share_plus`, do a **full stop + rebuild** (hot restart does not
///   register native plugins and causes [MissingPluginException]).
class ShareScoreService {
  /// Shows a preview dialog, then shares or saves the card as a PNG.
  Future<ShareScoreOutcome> shareSocialPostImage({
    required BuildContext context,
    required ShareScoreCard card,
    required String shareText,
  }) async {
    await precacheImage(
      const AssetImage(ShareScoreCard.appIconAsset),
      context,
    );
    if (!context.mounted) return ShareScoreOutcome.cancelled;

    final pngBytes = await showDialog<Uint8List>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      builder: (dialogContext) {
        return _ShareScorePreviewDialog(card: card);
      },
    );

    if (pngBytes == null || pngBytes.isEmpty) {
      return ShareScoreOutcome.cancelled;
    }
    if (!context.mounted) return ShareScoreOutcome.cancelled;

    // Let the dialog fully dismiss before presenting the native sheet.
    await Future<void>.delayed(const Duration(milliseconds: 120));
    if (!context.mounted) return ShareScoreOutcome.cancelled;

    final fileName =
        'snake_app_score_${DateTime.now().millisecondsSinceEpoch}.png';
    return sharePngBytes(
      context: context,
      pngBytes: pngBytes,
      shareText: shareText,
      fileName: fileName,
    );
  }

  Future<ShareScoreOutcome> sharePngBytes({
    required BuildContext context,
    required Uint8List pngBytes,
    required String shareText,
    required String fileName,
  }) async {
    if (pngBytes.isEmpty) return ShareScoreOutcome.failed;

    final shareOrigin = _shareOriginFor(context);
    final shareFile = await _writeShareFile(
      pngBytes: pngBytes,
      fileName: fileName,
    );
    if (shareFile == null) return ShareScoreOutcome.failed;

    if (_canUseNativeFileShare) {
      final nativeOutcome = await _tryNativeShare(
        filePath: shareFile.path,
        fileName: fileName,
        pngBytes: pngBytes,
        shareText: shareText,
        shareOrigin: shareOrigin,
      );
      if (nativeOutcome == ShareScoreOutcome.shared) {
        return ShareScoreOutcome.shared;
      }
      // Mobile/web: do not silently write Downloads when the sheet fails.
      if (!_shouldFallbackToDiskSave) {
        return ShareScoreOutcome.failed;
      }
    }

    final savedPath = await _saveForDesktopSharing(
      pngBytes: pngBytes,
      fileName: fileName,
    );
    if (savedPath == null) return ShareScoreOutcome.failed;

    await _revealFile(savedPath);
    return ShareScoreOutcome.savedToDisk;
  }

  /// Native file share works everywhere share_plus supports files.
  /// Linux only supports text (mailto), not image files.
  bool get _canUseNativeFileShare {
    if (kIsWeb) return true;
    if (Platform.isLinux) return false;
    return Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isMacOS ||
        Platform.isWindows;
  }

  /// Desktop can always fall back to saving a PNG the user can attach manually.
  bool get _shouldFallbackToDiskSave {
    if (kIsWeb) return false;
    return Platform.isLinux || Platform.isMacOS || Platform.isWindows;
  }

  Future<ShareScoreOutcome> _tryNativeShare({
    required String filePath,
    required String fileName,
    required Uint8List pngBytes,
    required String shareText,
    required Rect shareOrigin,
  }) async {
    try {
      if (kIsWeb) {
        final withCaption = await SharePlus.instance.share(
          ShareParams(
            files: [
              XFile.fromData(
                pngBytes,
                mimeType: 'image/png',
                name: fileName,
              ),
            ],
            fileNameOverrides: [fileName],
            text: shareText,
            subject: AppConstants.appName,
            title: AppConstants.appName,
            sharePositionOrigin: shareOrigin,
          ),
        );
        if (withCaption.status != ShareResultStatus.unavailable) {
          return ShareScoreOutcome.shared;
        }

        final imageOnly = await SharePlus.instance.share(
          ShareParams(
            files: [
              XFile.fromData(
                pngBytes,
                mimeType: 'image/png',
                name: fileName,
              ),
            ],
            fileNameOverrides: [fileName],
            sharePositionOrigin: shareOrigin,
          ),
        );
        return imageOnly.status == ShareResultStatus.unavailable
            ? ShareScoreOutcome.failed
            : ShareScoreOutcome.shared;
      }

      final withCaption = await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile(filePath, mimeType: 'image/png', name: fileName),
          ],
          fileNameOverrides: [fileName],
          text: shareText,
          subject: AppConstants.appName,
          title: AppConstants.appName,
          sharePositionOrigin: shareOrigin,
        ),
      );
      if (withCaption.status != ShareResultStatus.unavailable) {
        return ShareScoreOutcome.shared;
      }

      final imageOnly = await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile(filePath, mimeType: 'image/png', name: fileName),
          ],
          fileNameOverrides: [fileName],
          sharePositionOrigin: shareOrigin,
        ),
      );
      return imageOnly.status == ShareResultStatus.unavailable
          ? ShareScoreOutcome.failed
          : ShareScoreOutcome.shared;
    } on MissingPluginException catch (error, stackTrace) {
      debugPrint(
        'Share plugin not registered (stop the app and fully rebuild; '
        'hot restart cannot load new native plugins): $error\n$stackTrace',
      );
      return ShareScoreOutcome.failed;
    } catch (error, stackTrace) {
      debugPrint('Share image failed: $error\n$stackTrace');
      return ShareScoreOutcome.failed;
    }
  }

  Future<File?> _writeShareFile({
    required Uint8List pngBytes,
    required String fileName,
  }) async {
    try {
      if (kIsWeb) return null;
      final directory = await getTemporaryDirectory();
      // Must not use a folder whose path starts with ".../share_plus":
      // share_plus Android rejects those (prefix check on its cache dir).
      final shareDirectory = Directory('${directory.path}/snake_app_share');
      if (!await shareDirectory.exists()) {
        await shareDirectory.create(recursive: true);
      }
      final file = File('${shareDirectory.path}/$fileName');
      await file.writeAsBytes(pngBytes, flush: true);
      return file;
    } catch (error, stackTrace) {
      debugPrint('Write share file failed: $error\n$stackTrace');
      return null;
    }
  }

  /// Prefer Downloads; fall back to Documents / temp for desktop reveal.
  Future<String?> _saveForDesktopSharing({
    required Uint8List pngBytes,
    required String fileName,
  }) async {
    if (kIsWeb) return null;
    try {
      Directory? targetDirectory = await getDownloadsDirectory();
      targetDirectory ??= await getApplicationDocumentsDirectory();

      final exportDirectory = Directory(
        '${targetDirectory.path}/Snake App',
      );
      if (!await exportDirectory.exists()) {
        await exportDirectory.create(recursive: true);
      }
      final file = File('${exportDirectory.path}/$fileName');
      await file.writeAsBytes(pngBytes, flush: true);
      return file.path;
    } catch (error, stackTrace) {
      debugPrint('Desktop save failed: $error\n$stackTrace');
      try {
        final temporary = await getTemporaryDirectory();
        final file = File('${temporary.path}/$fileName');
        await file.writeAsBytes(pngBytes, flush: true);
        return file.path;
      } catch (_) {
        return null;
      }
    }
  }

  Future<void> _revealFile(String filePath) async {
    if (kIsWeb) return;
    try {
      if (Platform.isMacOS) {
        await Process.run('open', ['-R', filePath]);
      } else if (Platform.isWindows) {
        await Process.run('explorer', ['/select,', filePath]);
      } else if (Platform.isLinux) {
        final folderPath = File(filePath).parent.path;
        await Process.run('xdg-open', [folderPath]);
      }
    } catch (error, stackTrace) {
      debugPrint('Reveal share file failed: $error\n$stackTrace');
    }
  }

  /// iOS (esp. iPad / newer iOS) requires a non-zero origin inside the screen.
  Rect _shareOriginFor(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize && box.size.width > 0 && box.size.height > 0) {
      final origin = box.localToGlobal(Offset.zero);
      final rect = origin & box.size;
      if (rect.width > 0 && rect.height > 0) return rect;
    }

    final size = MediaQuery.sizeOf(context);
    final width = size.width.clamp(1.0, 120.0);
    final height = size.height.clamp(1.0, 120.0);
    return Rect.fromLTWH(
      (size.width - width) / 2,
      (size.height - height) / 2,
      width,
      height,
    );
  }

  static Future<Uint8List?> capturePng(GlobalKey repaintKey) async {
    final boundary = repaintKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) return null;

    await Future<void>.delayed(const Duration(milliseconds: 50));
    await WidgetsBinding.instance.endOfFrame;

    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }
}

class _ShareScorePreviewDialog extends StatefulWidget {
  const _ShareScorePreviewDialog({required this.card});

  final ShareScoreCard card;

  @override
  State<_ShareScorePreviewDialog> createState() =>
      _ShareScorePreviewDialogState();
}

class _ShareScorePreviewDialogState extends State<_ShareScorePreviewDialog> {
  final GlobalKey _repaintKey = GlobalKey();
  bool _isPreparing = false;

  Future<void> _onShare() async {
    if (_isPreparing) return;
    setState(() => _isPreparing = true);
    final l10n = context.l10n;
    try {
      final pngBytes = await ShareScoreService.capturePng(_repaintKey);
      if (!mounted) return;
      if (pngBytes == null || pngBytes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.shareFailed)),
        );
        setState(() => _isPreparing = false);
        return;
      }
      // Return bytes to the caller; native share opens after this dialog pops.
      Navigator.of(context).pop(pngBytes);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.shareFailed)),
      );
      setState(() => _isPreparing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final maxHeight = MediaQuery.sizeOf(context).height * 0.86;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight, maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.sharePreviewTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.sharePreviewSubtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: SingleChildScrollView(
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: RepaintBoundary(
                        key: _repaintKey,
                        child: widget.card,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: _isPreparing ? null : _onShare,
                icon: _isPreparing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.image_outlined),
                label: Text(
                  _isPreparing ? l10n.sharePreparing : l10n.shareAsImageConfirm,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _isPreparing
                    ? null
                    : () => Navigator.of(context).pop(),
                child: Text(l10n.back),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
