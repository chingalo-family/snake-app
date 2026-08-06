import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:snake_app/core/constants/app_constants.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/core/utils/page_insets.dart';
import 'package:snake_app/modules/about/components/about_info_line.dart';
import 'package:snake_app/shared/widgets/app_chrome.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: SnakePageAppBar(
        title: Text(l10n.about),
        showBackButton: true,
        showHomeButton: true,
        showMoreButton: true,
      ),
      body: AtmosphereBackground(
        child: FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) {
            final packageInfo = snapshot.data;
            final theme = Theme.of(context);
            return ListView(
              padding: pageScrollPadding(context),
              children: [
                const BrandMark(),
                const SizedBox(height: 20),
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.aboutDescription,
                        style: theme.textTheme.bodyLarge?.copyWith(height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      AboutInfoLine(
                        label: l10n.version,
                        value: packageInfo?.version ?? '…',
                      ),
                      AboutInfoLine(
                        label: l10n.build,
                        value: packageInfo?.buildNumber ?? '…',
                      ),
                      AboutInfoLine(
                        label: l10n.package,
                        value: AppConstants.packageId,
                      ),
                      AboutInfoLine(
                        label: l10n.madeBy,
                        value: AppConstants.familyCredit,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.highlights,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(l10n.highlightSwipe),
                      Text(l10n.highlightOrientation),
                      Text(l10n.highlightAudio),
                      Text(l10n.highlightProfile),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
