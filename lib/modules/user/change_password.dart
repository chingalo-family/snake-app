import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snake_app/core/components/app_bar_container.dart';
import 'package:snake_app/core/components/material_card.dart';
import 'package:snake_app/core/services/user_service.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isChanging = false;
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isChanging = true;
      });

      try {
        final userService = UserService();
        final message = await userService.changeCurrentUserPassword(
          _oldPasswordController.text,
          _newPasswordController.text,
        );

        if (mounted) {
          if (message.isEmpty) {
            // Success
            Fluttertoast.showToast(
              msg: "Password changed successfully!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
            );

            // Note: Password is not stored locally for security reasons.
            // User will need to use the new password for next login.

            // Clear form and go back
            _oldPasswordController.clear();
            _newPasswordController.clear();
            _confirmPasswordController.clear();
            Navigator.pop(context);
          } else {
            // Error from server
            Fluttertoast.showToast(
              msg: message,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
            );
          }
        }
      } catch (error) {
        if (mounted) {
          Fluttertoast.showToast(
            msg: "Failed to change password. Please try again.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isChanging = false;
          });
        }
      }
    }
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: onToggleVisibility,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarContainer(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Header
              MaterialCard(
                elevation: 2.0,
                borderRadius: 16.0,
                body: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                        Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    children: [
                      const Text('🔐', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 15.0),
                      Text(
                        'Change Password',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Keep your account secure',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20.0),

              // Security Tips
              MaterialCard(
                elevation: 2.0,
                body: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('💡', style: TextStyle(fontSize: 24)),
                          const SizedBox(width: 10.0),
                          Text(
                            'Security Tips',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      _buildTipRow('Use at least 8 characters'),
                      const SizedBox(height: 8.0),
                      _buildTipRow('Mix letters, numbers & symbols'),
                      const SizedBox(height: 8.0),
                      _buildTipRow('Don\'t reuse old passwords'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20.0),

              // Password Change Form
              MaterialCard(
                elevation: 3.0,
                borderRadius: 16.0,
                body: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('🔑', style: TextStyle(fontSize: 24)),
                            const SizedBox(width: 10.0),
                            Text(
                              'Update Your Password',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),

                        _buildPasswordField(
                          controller: _oldPasswordController,
                          label: 'Current Password',
                          hint: 'Enter your current password',
                          obscureText: _obscureOldPassword,
                          onToggleVisibility: () {
                            setState(() {
                              _obscureOldPassword = !_obscureOldPassword;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your current password';
                            }
                            return null;
                          },
                        ),

                        _buildPasswordField(
                          controller: _newPasswordController,
                          label: 'New Password',
                          hint: 'Enter your new password',
                          obscureText: _obscureNewPassword,
                          onToggleVisibility: () {
                            setState(() {
                              _obscureNewPassword = !_obscureNewPassword;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a new password';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                        ),

                        _buildPasswordField(
                          controller: _confirmPasswordController,
                          label: 'Confirm New Password',
                          hint: 'Re-enter your new password',
                          obscureText: _obscureConfirmPassword,
                          onToggleVisibility: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your new password';
                            }
                            if (value != _newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 10.0),

                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _isChanging ? null : _changePassword,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: _isChanging
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                        Theme.of(context).colorScheme.onPrimary,
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('✅', style: TextStyle(fontSize: 20)),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'Change Password',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipRow(String tip) {
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          size: 18,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            tip,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
