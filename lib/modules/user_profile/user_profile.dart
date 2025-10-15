import 'package:flutter/material.dart';
import 'package:snake_app/core/components/app_bar_container.dart';

class Userprofile extends StatelessWidget {
  const Userprofile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarContainer(),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: const Center(child: Text('user profile Page')),
      ),
    );
  }
}
