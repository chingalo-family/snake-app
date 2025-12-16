import 'package:flutter/material.dart';
import 'package:snake_app/core/models/input_field.dart';
import 'package:snake_app/core/utils/entry_form_util.dart';
import 'package:snake_app/core/components/entry_input_fields/input_field_controller_mixin.dart';

// `NumericalInputFieldContainer` is an input field container for numerical input fields
class NumericalInputFieldContainer extends StatefulWidget {
  // `InputField` metadata for the numerical input field container
  final InputField inputField;

  // `Function` callback called when input values had changed
  final Function onInputValueChange;

  // `String` value for the numerical field
  final String? inputValue;

  //
  // this is a default constructor for `NumericalInputFieldContainer`
  // the constructor accepts `String` value for the numerical field, `Function` callback called when input values had changed and `InputField` metadata for the numerical input field container
  //
  const NumericalInputFieldContainer({
    super.key,
    required this.inputField,
    required this.onInputValueChange,
    this.inputValue,
  });

  @override
  State<NumericalInputFieldContainer> createState() =>
      _NumericalInputFieldContainerState();
}

class _NumericalInputFieldContainerState
    extends State<NumericalInputFieldContainer>
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
    String sanitizedValue = EntryFormUtil.getSanitizedNumericalValue(value);
    setState(() {});
    widget.onInputValueChange(sanitizedValue.trim());
  }

  @override
  void didUpdateWidget(covariant NumericalInputFieldContainer oldWidget) {
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
