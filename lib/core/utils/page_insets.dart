import 'package:flutter/widgets.dart';

EdgeInsets pageScrollPadding(
  BuildContext context, {
  double left = 20,
  double top = 8,
  double right = 20,
  double bottom = 28,
}) {
  return EdgeInsets.fromLTRB(
    left,
    top,
    right,
    bottom + MediaQuery.viewPaddingOf(context).bottom,
  );
}
