import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/user_state/user_entry_form_state.dart';
import 'package:snake_app/core/app_state/user_state/user_state.dart';
import 'package:snake_app/core/components/circular_process_loader.dart';
import 'package:snake_app/core/components/entry_forms/entry_form_container.dart';
import 'package:snake_app/core/constants/email_connection.dart';
import 'package:snake_app/core/models/email_notification.dart';
import 'package:snake_app/core/models/form_section.dart';
import 'package:snake_app/core/models/user.dart';
import 'package:snake_app/core/services/email_service.dart';
import 'package:snake_app/core/services/user_service.dart';
import 'package:snake_app/core/utils/app_util.dart';
import 'package:snake_app/core/utils/email_templates.dart';
import 'package:snake_app/modules/game/game.dart';
import 'package:snake_app/modules/user/models/sign_up_form.dart';

class SignUpContainer extends StatefulWidget {
  const SignUpContainer({super.key});

  @override
  State<SignUpContainer> createState() => _SignUpContainerState();
}

class _SignUpContainerState extends State<SignUpContainer> {
  List<FormSection> formSections = [];
  Map mandatoryFieldObject = {};
  bool _isFormReady = false;
  bool _isSaving = false;

  @override
  void initState() {
    setFormMetadata();
    super.initState();
    Timer(const Duration(milliseconds: 500), () {
      _isFormReady = true;
      setState(() {});
    });
  }

  void setFormMetadata() {
    formSections = SignUpForm.getFormFields();
    for (String id in SignUpForm.getFormMandatoryFieldIds()) {
      mandatoryFieldObject[id] = true;
    }
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<UserEntryFormState>(
      context,
      listen: false,
    ).setFormFieldState(id, value);
  }

  onSignUp(Map dataObject) async {
    try {
      _isSaving = true;
      setState(() {});
      User? user = await UserService().signUpUser(dataObject);
      if (user != null) {
        await UserService().setCurrentUser(user);
        
        // Send welcome emails
        _sendWelcomeEmails(user);
        
        _onSuccessSignUp(user);
      }
    } catch (error) {
      _isSaving = false;
      setState(() {});
      AppUtil.showToastMessage(message: error.toString());
    }
  }

  void _sendWelcomeEmails(User user) async {
    try {
      // Only send welcome email to user if they have an email
      if (user.email != null && user.email!.isNotEmpty) {
        final welcomeHtml = EmailTemplates.getWelcomeEmail(
          username: user.username,
          fullName: user.fullName,
        );
        
        final userEmail = EmailNotification(
          recipients: [user.email!],
          subject: 'Welcome to Snake App! 🎉',
          textBody: 'Welcome to Snake App! Your account has been successfully created.',
          htmlBody: welcomeHtml,
        );
        
        await EmailService.sendEmail(emailNotification: userEmail);
      }

      // Send notification to admins
      final adminNotificationHtml = EmailTemplates.getNewSignupNotificationEmail(
        username: user.username,
        fullName: user.fullName,
        email: user.email ?? 'Not provided',
      );
      
      final adminEmail = EmailNotification(
        recipients: [EmailConnection.senderEmail],
        subject: 'New User Registration: ${user.username}',
        textBody: 'New user ${user.username} (${user.fullName}) has registered.',
        htmlBody: adminNotificationHtml,
      );
      
      await EmailService.sendEmail(emailNotification: adminEmail);
    } catch (error) {
      debugPrint('Failed to send welcome emails: $error');
      // Don't fail signup if email sending fails
    }
  }

  void _onSuccessSignUp(User user) async {
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
                bool isSignUpFormValid = userEntryFormState.isSignUpFormValid;
                return Column(
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
                        onPressed: !isSignUpFormValid
                            ? null
                            : () => _isSaving
                                  ? null
                                  : onSignUp(userEntryFormState.formState),
                        child: Text(
                          _isSaving ? "Creating Account..." : "Sign Up",
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
          : const Center(child: CircularProcessLoader(size: 2.0)),
    );
  }
}
