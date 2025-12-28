import 'package:flutter/material.dart';

/// Reusable labeled text field component
class LabeledTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final String? Function(String?) validator;
  final int maxLines;
  final TextInputType keyboardType;
  final Widget? prefixIcon;

  const LabeledTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    required this.validator,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8.0),
        Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: prefixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
