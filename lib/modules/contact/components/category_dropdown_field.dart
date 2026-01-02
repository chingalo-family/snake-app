import 'package:flutter/material.dart';

/// Reusable category dropdown field component
class CategoryDropdownField extends StatelessWidget {
  final String value;
  final Function(String?) onChanged;

  const CategoryDropdownField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8.0),
        Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.category_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.3),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: 'General Inquiry',
                child: Text('General Inquiry'),
              ),
              DropdownMenuItem(
                value: 'Technical Support',
                child: Text('Technical Support'),
              ),
              DropdownMenuItem(
                value: 'Bug Report',
                child: Text('Bug Report'),
              ),
              DropdownMenuItem(
                value: 'Feature Request',
                child: Text('Feature Request'),
              ),
              DropdownMenuItem(
                value: 'Feedback',
                child: Text('Feedback'),
              ),
            ],
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
