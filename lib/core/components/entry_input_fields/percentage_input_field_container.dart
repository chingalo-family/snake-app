import 'package:flutter/material.dart';
import 'package:snake_app/core/models/input_field.dart';
import 'package:snake_app/core/components/entry_input_fields/input_field_controller_mixin.dart';

// `PercentageInputFieldContainer` is a container for the percentage input fields
class PercentageInputFieldContainer extends StatefulWidget {
  // `InputField` is the input field metadata for the percentage input field container
  final InputField inputField;

  // `Function` callback called when input values had changed
  final Function onInputValueChange;

  // `Function` callback called to set validation errors
  final Function setValidationError;

  // `String` value for the percentage input field
  final String? inputValue;

  //
  // this is the default constructor for the `PercentageInputFieldContainer`
  //  the constructor accepts `Function` callback called to set validation errors, `InputField` that is the input field metadata, `Function` callback called when input values had changed and a `String` value for the percentage input field
  //
  const PercentageInputFieldContainer({
    super.key,
    required this.inputField,
    required this.onInputValueChange,
    required this.setValidationError,
    this.inputValue,
  });

  @override
  State<PercentageInputFieldContainer> createState() =>
      _PercentageInputFieldContainerState();
}

class _PercentageInputFieldContainerState
    extends State<PercentageInputFieldContainer>
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
    widget.setValidationError(false);
    if (value.isNotEmpty) {
      try {
        double percentageValue = double.parse(value);
        if (percentageValue >= 0 && percentageValue <= 100) {
          widget.setValidationError(false);
          widget.onInputValueChange(percentageValue.toString());
        } else {
          widget.setValidationError(true);
        }
      } catch (e) {
        //
        widget.setValidationError(true);
      }
    }
  }

  @override
  void didUpdateWidget(covariant PercentageInputFieldContainer oldWidget) {
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
            keyboardType: TextInputType.number,
            onChanged: onValueChange,
            style: const TextStyle().copyWith(
              color: widget.inputField.inputColor,
            ),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.inputField.hint!,
              errorText: null,
            ),
          ),
        ),
      ],
    );
  }
}
