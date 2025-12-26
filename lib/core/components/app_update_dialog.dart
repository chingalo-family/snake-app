import 'package:flutter/material.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/app_update_state/app_update_state.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/core/models/app_update_version.dart';
import 'package:snake_app/core/services/app_update_service.dart';

class AppUpdateDialog extends StatelessWidget {
  final AppUpdateService updateService;

  const AppUpdateDialog({
    super.key,
    required this.updateService,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppUpdateState>(
      builder: (context, updateState, child) {
        final status = updateState.status;
        final availableUpdate = updateState.availableUpdate;

        if (status == AppUpdateStatus.updateAvailable && availableUpdate != null) {
          return _buildUpdateAvailableDialog(context, updateState, availableUpdate);
        } else if (status == AppUpdateStatus.downloading) {
          return _buildDownloadingDialog(context, updateState);
        } else if (status == AppUpdateStatus.downloaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _installApk(context, updateState);
          });
          return const SizedBox.shrink();
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildUpdateAvailableDialog(
    BuildContext context,
    AppUpdateState updateState,
    AppUpdateVersion availableUpdate,
  ) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Row(
        children: [
          Icon(
            Icons.system_update,
            color: AppInfoReference.defaultAppColor,
            size: 28.0,
          ),
          const SizedBox(width: 12.0),
          const Text(
            'Update Available',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'A new version (${availableUpdate.version}) is available.',
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            'Current version: ${AppInfoReference.currentAppVersion}',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Would you like to download and install the update now?',
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
        ],
      ),
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppInfoReference.defaultAppColor,
            side: const BorderSide(color: AppInfoReference.defaultAppColor),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            updateState.resetState();
          },
          child: const Text('Later'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppInfoReference.defaultAppColor,
          ),
          onPressed: () {
            updateState.downloadUpdate(updateService);
          },
          child: const Text('Download & Install'),
        ),
      ],
    );
  }

  Widget _buildDownloadingDialog(
    BuildContext context,
    AppUpdateState updateState,
  ) {
    final progress = updateState.downloadProgressPercentage;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: const Text(
        'Downloading Update',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16.0),
          LinearProgressIndicator(
            value: progress > 0 ? progress / 100 : null,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppInfoReference.defaultAppColor,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            progress > 0 ? '${progress.toStringAsFixed(1)}%' : 'Preparing...',
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _installApk(BuildContext context, AppUpdateState updateState) async {
    final apkPath = updateState.downloadedApkPath;
    if (apkPath == null) return;

    try {
      await InstallPlugin.install(apkPath);
      if (context.mounted) {
        Navigator.of(context).pop();
        updateState.resetState();
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to install update: $e'),
            backgroundColor: Colors.red,
          ),
        );
        updateState.resetState();
      }
    }
  }
}
