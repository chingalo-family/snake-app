import 'package:flutter/material.dart';

/// Reusable contact information display component
class ContactInfoSection extends StatelessWidget {
  final String email;
  final String? phone;

  const ContactInfoSection({
    super.key,
    required this.email,
    this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Other Ways to Reach Us',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16.0),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: 1.0,
            ),
          ),
          child: Column(
            children: [
              _buildContactRow(
                context,
                icon: Icons.email_outlined,
                label: 'Email',
                value: email,
              ),
              if (phone != null) ...[
                const SizedBox(height: 12.0),
                _buildContactRow(
                  context,
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: phone!,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
