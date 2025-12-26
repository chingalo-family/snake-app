import 'package:flutter/material.dart';
import 'package:snake_app/core/models/input_field.dart';
import 'package:snake_app/core/utils/entry_form_util.dart';
import 'package:snake_app/core/components/entry_input_fields/input_field_controller_mixin.dart';

class PhoneNumberInputFieldContainer extends StatefulWidget {
  // `InputField` is the input field metadata for the phone number input field container
  final InputField inputField;

  // `Function` callback called when input values had changed
  final Function onInputValueChange;

  // `Function` callback called when value is either valid or not for set validation error
  final Function setValidationError;

  // `String` value for the phone number field
  final String? inputValue;

  //
  // this is a default constructor for the `PhoneNumberInputFieldContainer`
  // the constructor accepts `String` value for the phone number field, `Function` callback called when input values had changed and  `InputField` metadata
  const PhoneNumberInputFieldContainer({
    super.key,
    required this.inputField,
    required this.onInputValueChange,
    required this.setValidationError,
    this.inputValue,
  });

  @override
  State<PhoneNumberInputFieldContainer> createState() =>
      _PhoneNumberInputFieldContainerState();
}

class _PhoneNumberInputFieldContainerState
    extends State<PhoneNumberInputFieldContainer>
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
    bool isValidPhoneNumber = EntryFormUtil.isPhoneNumberValid(value..trim());
    widget.setValidationError(false);
    widget.onInputValueChange(value.trim());
    isValidPhoneNumber
        ? widget.setValidationError(false)
        : widget.setValidationError(true);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            readOnly: widget.inputField.isReadOnly!,
            controller: textController,
            keyboardType: TextInputType.phone,
            onChanged: onValueChange,
            style: const TextStyle().copyWith(
              color: widget.inputField.inputColor,
            ),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.inputField.hint,
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
