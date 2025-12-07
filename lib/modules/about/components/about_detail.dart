import 'package:flutter/material.dart';

class AboutDetail extends StatelessWidget {
  const AboutDetail({
    super.key,
    required this.textColor,
    required this.value,
  });

  final Color textColor;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          value,
          style: const TextStyle().copyWith(
            fontSize: 12.0,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
