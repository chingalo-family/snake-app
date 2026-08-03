import 'package:flutter/material.dart';
import 'package:snake_app/core/theme/app_colors.dart';

/// Pill page dots (Duka-style indicator).
class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.pageCount,
  });

  final int currentPage;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactive = isDark
        ? AppColors.darkTextMuted.withValues(alpha: 0.45)
        : const Color(0xFFD1D5DB);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (pageIndex) {
        final isActive = currentPage == pageIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.brandPrimary : inactive,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
