import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/modules/about/about.dart';

class MoreActionMenu extends StatelessWidget {
  const MoreActionMenu({super.key});

  void _onNavigateToAbout(BuildContext context) {
    Navigator.pop(context);
    Timer(
      const Duration(microseconds: 500),
      () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const About(),
          transitionDuration: const Duration(seconds: 0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.info_outline,
                  label: 'About',
                  onTap: () => _onNavigateToAbout(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppInfoReference.defaultAppColor,
      ),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white,
            ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      hoverColor: AppInfoReference.defaultAppColor.withOpacity(0.1),
    );
  }
}
