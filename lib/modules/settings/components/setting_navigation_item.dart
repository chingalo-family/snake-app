import 'package:flutter/material.dart';

/// Reusable navigation item component
class SettingNavigationItem extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;

  const SettingNavigationItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Text(icon, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(width: 15.0),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}
