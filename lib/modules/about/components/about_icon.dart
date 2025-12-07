import 'package:flutter/material.dart';

class AboutIcon extends StatelessWidget {
  const AboutIcon({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(
        bottom: 20.0,
      ),
      height: size.shortestSide * 0.3,
      child: const Image(
        fit: BoxFit.contain,
        image: AssetImage(
          'assets/img/app-icon.png',
        ),
      ),
    );
  }
}
