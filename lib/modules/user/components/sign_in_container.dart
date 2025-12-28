import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/user_state/user_entry_form_state.dart';
import 'package:snake_app/core/app_state/user_state/user_state.dart';
import 'package:snake_app/core/components/circular_process_loader.dart';
import 'package:snake_app/core/components/entry_forms/entry_form_container.dart';
import 'package:snake_app/core/models/form_section.dart';
import 'package:snake_app/core/models/user.dart';
import 'package:snake_app/core/services/user_service.dart';
import 'package:snake_app/core/utils/app_util.dart';
import 'package:snake_app/core/utils/entry_form_util.dart';
import 'package:snake_app/modules/game/game.dart';
import 'package:snake_app/modules/user/models/sign_in_form.dart';

class SignInContainer extends StatefulWidget {
  const SignInContainer({super.key});

  @override
  State<SignInContainer> createState() => _SignInContainerState();
}

class _SignInContainerState extends State<SignInContainer> {
  List<FormSection>? formSections;
  Map mandatoryFieldObject = {};
  bool _isFormReady = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    setFormMetadata();
    Timer(const Duration(milliseconds: 500), () {
      _isFormReady = true;
      setState(() {});
    });
  }

  void setFormMetadata() {
    formSections = SignInForm.getFormFields();
    List<String> ids = EntryFormUtil.getInputFieldIds(formSections!);
    for (String id in ids) {
      mandatoryFieldObject[id] = true;
    }
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<UserEntryFormState>(
      context,
      listen: false,
    ).setFormFieldState(id, value);
  }

  void onLogin(Map dataObject) async {
    try {
      _isSaving = true;
      setState(() {});
      String username = dataObject['username'] ?? '';
      String password = dataObject['password'] ?? '';
      var user = await UserService().login(
        username: username,
        password: password,
      );
      if (user != null) {
        await UserService().setCurrentUser(user);
        _onSuccessLogin(user);
      } else {
        _isSaving = false;
        setState(() {});
        AppUtil.showToastMessage(
          message: 'Wrong username or password, try again',
        );
      }
    } catch (error) {
      _isSaving = false;
      setState(() {});
      AppUtil.showToastMessage(message: error.toString());
    }
  }

  void _onSuccessLogin(User user) async {
    Provider.of<UserState>(context, listen: false).setCurrentUser(user);
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => Game(),
          transitionDuration: const Duration(seconds: 0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(),
      child: _isFormReady
          ? Consumer<UserEntryFormState>(
              builder: (context, userEntryFormState, child) {
                bool isLoginFormValid = userEntryFormState.isLoginFormValid;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      EntryFormContainer(
                        onInputValueChange: (String id, dynamic value) =>
                            onInputValueChange(id, value),
                        formSections: formSections,
                        dataObject: userEntryFormState.formState,
                        mandatoryFieldObject: mandatoryFieldObject,
                      ),
                      const SizedBox(height: 24.0),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          onPressed: !isLoginFormValid
                              ? null
                              : () => _isSaving
                                    ? null
                                    : onLogin(userEntryFormState.formState),
                          child: Text(
                            _isSaving ? "Signing In..." : "Sign In",
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : const Center(child: CircularProcessLoader(size: 2.0)),
    );
  }
}
