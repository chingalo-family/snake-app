import 'package:flutter/material.dart';

class GameSheetScaffold extends StatelessWidget {
  const GameSheetScaffold({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final maxHeight = MediaQuery.sizeOf(context).height * 0.85;

    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
