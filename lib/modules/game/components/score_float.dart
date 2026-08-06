import 'package:flutter/material.dart';
import 'package:snake_app/core/theme/app_colors.dart';

class ScoreFloat extends StatefulWidget {
  const ScoreFloat({
    super.key,
    required this.points,
    required this.onDone,
  });

  final int points;
  final VoidCallback onDone;

  @override
  State<ScoreFloat> createState() => _ScoreFloatState();
}

class _ScoreFloatState extends State<ScoreFloat>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward().whenComplete(widget.onDone);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final animationProgress = _controller.value;
        return Opacity(
          opacity: (1 - animationProgress).clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, -40 * animationProgress),
            child: child,
          ),
        );
      },
      child: Center(
        child: Text(
          '+${widget.points}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.brandSecondary,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
    );
  }
}
