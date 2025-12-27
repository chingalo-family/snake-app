// `EmailInputFieldContainer` is a class for the email input field
import 'package:flutter/material.dart';
import 'package:snake_app/core/models/input_field.dart';
import 'package:snake_app/core/utils/entry_form_util.dart';
import 'package:snake_app/core/components/entry_input_fields/input_field_controller_mixin.dart';

class EmailInputFieldContainer extends StatefulWidget {
  // `InputField` is the input field metadata for the email inputs
  final InputField inputField;

  // `Function` callback called when the input value has changed
  final Function onInputValueChange;

  // `Function` callback for setting validation errors when email validations have failed
  final Function setValidationError;

  // `String` value for the email input field
  final String? inputValue;

  //
  //  this is the default constructor for `EmailInputFieldContainer`
  // the constructor accepts `InputField` metadata, `String` value, a callback `Function` that is called when the value changed and a callback `Function` to set validation error messaged
  //
  const EmailInputFieldContainer({
    super.key,
    required this.inputField,
    required this.onInputValueChange,
    required this.setValidationError,
    this.inputValue,
  });

  @override
  State<EmailInputFieldContainer> createState() =>
      _EmailInputFieldContainerState();
}

class _EmailInputFieldContainerState extends State<EmailInputFieldContainer>
    with InputFieldControllerMixin {
  @override
  InputField get inputField => widget.inputField;

  @override
  String? get inputValue => widget.inputValue;

  @override
  void initState() {
    super.initState();
    updateControllerValue(value: widget.inputValue);
  }

  void onValueChange(String value) {
    bool isValidEmail = EntryFormUtil.isEmailValid(value.trim());
    widget.onInputValueChange(value.trim());
    isValidEmail
        ? widget.setValidationError(false)
        : widget.setValidationError(true);
  }

  @override
  void didUpdateWidget(covariant EmailInputFieldContainer oldWidget) {
    super.didUpdateWidget(widget);
    handleInputValueUpdate(oldWidget.inputValue, widget.inputValue);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            readOnly: widget.inputField.isReadOnly!,
            controller: widget.inputField.isReadOnly!
                ? TextEditingController(text: widget.inputValue)
                : textController,
            keyboardType: TextInputType.emailAddress,
            onChanged: onValueChange,
            style: const TextStyle().copyWith(
              color: widget.inputField.inputColor,
            ),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.inputField.hint!,
              errorText: null,
              suffixIconConstraints: const BoxConstraints(
                maxHeight: 20.0,
                minHeight: 20.0,
              ),
              suffixIcon: Visibility(
                visible: widget.inputField.suffixLabel != '',
                child: Text(
                  widget.inputField.suffixLabel ?? '',
                  style: const TextStyle().copyWith(
                    color: widget.inputField.inputColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
