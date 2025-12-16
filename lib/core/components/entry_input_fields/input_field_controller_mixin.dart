import 'package:flutter/material.dart';
import 'package:snake_app/core/models/input_field.dart';

/// Mixin to handle common TextEditingController management for input field containers.
/// Reduces duplication across email, numerical, percentage, and other input field containers.
mixin InputFieldControllerMixin<T extends StatefulWidget> on State<T> {
  TextEditingController? textController;
  
  /// InputField metadata - must be implemented by the widget
  InputField get inputField;
  
  /// Current input value - must be implemented by the widget
  String? get inputValue;

  /// Updates the text controller with a new value
  void updateControllerValue({String? value = ''}) {
    textController = TextEditingController(text: value);
    if (mounted) {
      setState(() {});
    }
  }

  /// Common logic for didUpdateWidget to handle controller updates
  void handleInputValueUpdate(String? oldValue, String? newValue) {
    if (oldValue != newValue) {
      if (inputField.isReadOnly!) {
        updateControllerValue(value: newValue);
      }
      if (newValue == null || newValue == '') {
        updateControllerValue();
      }
    }
  }

  @override
  void dispose() {
    textController?.dispose();
    super.dispose();
  }
}
