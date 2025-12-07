import 'package:flutter/material.dart';
import 'package:snake_app/core/components/app_bar_container.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarContainer(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text('Settings Page Placeholder'),
        ),
      ),
    );
  }
}
