import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/core/models/form_section.dart';
import 'package:snake_app/core/models/input_field.dart';

class SignUpForm {
  static List<String> getFormMandatoryFieldIds() {
    return ['firstName', 'surname', 'username', 'password', 'email'];
  }

  static List<FormSection> getFormFields() {
    return [
      FormSection(
        name: '',
        inputFields: [
          InputField(
            id: 'firstName',
            name: 'First Name',
            valueType: 'TEXT',
            labelColor: AppInfoReference.defaultAppColor,
            inputColor: AppInfoReference.defaultAppColor,
          ),
          InputField(
            id: 'surname',
            name: 'Surname',
            valueType: 'TEXT',
            labelColor: AppInfoReference.defaultAppColor,
            inputColor: AppInfoReference.defaultAppColor,
          ),
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
            description:
                'Password must contain at least one uppercase letter, one lowercase letter, one number and one special character and length of at least 8 characters.',
            labelColor: AppInfoReference.defaultAppColor,
            inputColor: AppInfoReference.defaultAppColor,
          ),
          InputField(
            id: 'email',
            name: 'E-mail',
            valueType: 'EMAIL',
            labelColor: AppInfoReference.defaultAppColor,
            inputColor: AppInfoReference.defaultAppColor,
          ),
          InputField(
            id: 'phoneNumber',
            name: 'Phone Number',
            valueType: 'PHONE_NUMBER',
            labelColor: AppInfoReference.defaultAppColor,
            inputColor: AppInfoReference.defaultAppColor,
          ),
        ],
      ),
    ];
  }
}
