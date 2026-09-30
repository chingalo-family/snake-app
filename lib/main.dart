import 'package:flutter/material.dart';
import 'package:snake_app/app/bootstrap.dart';
import 'package:snake_app/app/startup_gate.dart';
import 'package:snake_app/core/utils/system_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureSystemUi();
  // Paint before prefs, SQLite, or audio. A hung plugin on a fresh Play
  // Store install otherwise leaves the native launch screen up forever.
  runApp(StartupGate(start: bootstrap));
}
