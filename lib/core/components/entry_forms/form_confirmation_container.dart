import 'package:flutter/material.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';

class FormConfirmationContainer extends StatelessWidget {
  const FormConfirmationContainer({
    super.key,
    required this.onConfirm,
    required this.confirmLabel,
  });

  final VoidCallback onConfirm;
  final String confirmLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          child: OutlinedButton(
            style: const ButtonStyle().copyWith(
              foregroundColor: const WidgetStatePropertyAll(
                AppInfoReference.defaultAppColor,
              ),
              side: WidgetStatePropertyAll(
                const BorderSide().copyWith(
                  color: AppInfoReference.defaultAppColor,
                ),
              ),
              textStyle: WidgetStateProperty.all(
                const TextStyle().copyWith(
                  color: AppInfoReference.defaultAppColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          child: FilledButton(
            style: const ButtonStyle().copyWith(
              backgroundColor: WidgetStateProperty.all(
                AppInfoReference.defaultAppColor,
              ),
              textStyle: WidgetStateProperty.all(
                const TextStyle().copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            onPressed: onConfirm,
            child: Text(confirmLabel),
          ),
        ),
      ],
    );
  }
}
