import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snake_app/app/routes.dart';

void popOrGoHome(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(AppRoutes.home);
  }
}
