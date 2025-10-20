import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/core/models/form_section.dart';
import 'package:snake_app/core/models/input_field.dart';

class SignInForm {
  static List<FormSection> getFormFields() {
    return [
      FormSection(
        name: '',
        inputFields: [
          InputField(
            id: 'username',
            name: 'Username',
            valueType: 'TEXT',
            labelColor: AppInfoReference.defaultAppColor,
            inputColor: AppInfoReference.defaultAppColor,
          ),
          InputField(
            id: 'password',
            name: 'Password',
            valueType: 'TEXT',
            isPasswordField: true,
            labelColor: AppInfoReference.defaultAppColor,
            inputColor: AppInfoReference.defaultAppColor,
          ),
        ],
      ),
    ];
  }
}
