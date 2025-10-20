import 'package:flutter/foundation.dart';
import 'package:snake_app/core/utils/entry_form_util.dart';

class UserEntryFormState with ChangeNotifier {
  // intial state
  final Map _formState = {};
  Map _hiddenFields = {};
  Map _hiddenInputFieldOptions = {};
  Map _hiddenSections = {};
  bool _isEditableMode = true;
  bool _isLoginFormValid = false;
  bool _isSignUpFormValid = false;

  // selector
  Map get formState => _formState;
  Map get hiddenFields => _hiddenFields;
  Map get hiddenSections => _hiddenSections;
  Map get hiddenInputFieldOptions => _hiddenInputFieldOptions;
  bool get isEditableMode => _isEditableMode;
  bool get isLoginFormValid => _isLoginFormValid;
  bool get isSignUpFormValid => _isSignUpFormValid;

  void setSignUpFormValidity() {
    String firstName = _formState['firstName'] ?? '';
    String surname = _formState['surname'] ?? '';
    String username = _formState['username'] ?? '';
    String email = _formState['email'] ?? '';
    String password = _formState['password'] ?? '';
    String phoneNumber = _formState['phoneNumber'] ?? '';
    bool isOtherFormValid =
        firstName.isNotEmpty &&
        surname.isNotEmpty &&
        username.isNotEmpty &&
        EntryFormUtil.isPasswordValid(password) &&
        EntryFormUtil.isEmailValid(email);
    _isSignUpFormValid = phoneNumber.isEmpty
        ? isOtherFormValid
        : isOtherFormValid && EntryFormUtil.isPhoneNumberValid(phoneNumber);
    notifyListeners();
  }

  void setLoginFormValidity() {
    String username = _formState['username'] ?? '';
    String password = _formState['password'] ?? '';
    _isLoginFormValid = username.isNotEmpty && password.isNotEmpty;
    notifyListeners();
  }

  void resetFormState() {
    _formState.clear();
    _hiddenFields.clear();
    _hiddenSections.clear();
    _hiddenInputFieldOptions.clear();
    setLoginFormValidity();
    setSignUpFormValidity();
    notifyListeners();
  }

  void updateFormEditabilityState({bool isEditableMode = true}) {
    _isEditableMode = isEditableMode;
    notifyListeners();
  }

  void setHiddenInputFieldOptions(Map hiddenInputFieldOptions) {
    _hiddenInputFieldOptions = hiddenInputFieldOptions;
    notifyListeners();
  }

  void setHiddenFields(Map hiddenFields) {
    _hiddenFields = hiddenFields;
    notifyListeners();
  }

  void setHiddenSections(Map hiddenSections) {
    _hiddenSections = hiddenSections;
    notifyListeners();
  }

  void setFormFieldState(String id, dynamic value) {
    _formState[id] = value ?? '';
    notifyListeners();
    setLoginFormValidity();
    setSignUpFormValidity();
  }

  void removeFieldFromState(String id) {
    _formState.remove(id);
    notifyListeners();
  }
}
