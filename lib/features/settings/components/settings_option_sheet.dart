import 'package:flutter/material.dart';
import 'package:snake_app/core/theme/app_colors.dart';

/// Bottom sheet option list — Duka settings selector pattern, Snake palette.
Future<void> showSettingsOptionSheet({
  required BuildContext context,
  required String title,
  required List<String> options,
  required String selectedOption,
  required ValueChanged<String> onSelect,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: AppColors.darkRaised,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Text(
                  title,
                  style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              for (var optionIndex = 0;
                  optionIndex < options.length;
                  optionIndex++) ...[
                if (optionIndex > 0)
                  const Divider(
                    height: 1,
                    indent: 20,
                    endIndent: 20,
                    color: AppColors.darkGridLine,
                  ),
                _SettingsOptionRow(
                  label: options[optionIndex],
                  isSelected: options[optionIndex] == selectedOption,
                  onTap: () {
                    onSelect(options[optionIndex]);
                    Navigator.of(sheetContext).pop();
                  },
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}

class _SettingsOptionRow extends StatelessWidget {
  const _SettingsOptionRow({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? AppColors.brandPrimaryLight
                        : theme.colorScheme.onSurface,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.brandPrimaryLight,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
