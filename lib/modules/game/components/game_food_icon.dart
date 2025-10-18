import 'package:flutter/material.dart';

class GameFoodIcon extends StatefulWidget {
  const GameFoodIcon({super.key, required this.icon});

  final String icon;

  @override
  State<GameFoodIcon> createState() => _GameFoodIconState();
}

class _GameFoodIconState extends State<GameFoodIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scaleAnimation, child: Text(widget.icon));
  }
}
