import 'package:flutter/material.dart';

/// Reusable settings section component with header and children
class SettingsSection extends StatelessWidget {
  final String title;
  final String icon;
  final List<Widget> children;
  final bool isLoading;

  const SettingsSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(icon, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(width: 10.0),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        if (isLoading)
          Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        else
          ...children,
      ],
    );
  }
}
