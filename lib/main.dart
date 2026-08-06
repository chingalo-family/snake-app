import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snake_app/app/app.dart';
import 'package:snake_app/app/bootstrap.dart';
import 'package:snake_app/core/utils/system_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureSystemUi();
  final container = await bootstrap();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const SnakeApp(),
    ),
  );
}
