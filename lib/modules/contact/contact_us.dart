import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snake_app/core/components/app_bar_container.dart';
import 'package:snake_app/core/components/material_card.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/core/constants/email_connection.dart';
import 'package:snake_app/core/models/email_notification.dart';
import 'package:snake_app/core/services/email_service.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });

      try {
        final emailNotification = EmailNotification(
          recipients: [EmailConnection.senderEmail],
          subject: 'Contact Form: ${_subjectController.text}',
          textBody: '''
Name: ${_nameController.text}
Email: ${_emailController.text}
Subject: ${_subjectController.text}

Message:
${_messageController.text}
''',
          htmlBody: null,
        );

        await EmailService.sendEmail(emailNotification: emailNotification);

        if (mounted) {
          Fluttertoast.showToast(
            msg: "Message sent successfully!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
          );

          // Clear form
          _nameController.clear();
          _emailController.clear();
          _subjectController.clear();
          _messageController.clear();

          Navigator.pop(context);
        }
      } catch (error) {
        if (mounted) {
          Fluttertoast.showToast(
            msg: "Failed to send message. Please try again.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSending = false;
          });
        }
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String? Function(String?) validator,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
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
                      const Text('📧', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 15.0),
                      Text(
                        'Contact Us',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'We\'d love to hear from you!',
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

              // Contact Information
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
                          const Text('ℹ️', style: TextStyle(fontSize: 24)),
                          const SizedBox(width: 10.0),
                          Text(
                            'Get in Touch',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      Row(
                        children: [
                          const Text('📧', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                      ),
                                ),
                                Text(
                                  EmailConnection.senderEmail,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: AppInfoReference.defaultAppColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20.0),

              // Contact Form
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
                            const Text('✉️', style: TextStyle(fontSize: 24)),
                            const SizedBox(width: 10.0),
                            Text(
                              'Send us a Message',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),

                        _buildTextField(
                          controller: _nameController,
                          label: 'Name',
                          hint: 'Enter your full name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),

                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          hint: 'Enter your email address',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            // More comprehensive email validation pattern
                            if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),

                        _buildTextField(
                          controller: _subjectController,
                          label: 'Subject',
                          hint: 'What is this about?',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a subject';
                            }
                            return null;
                          },
                        ),

                        _buildTextField(
                          controller: _messageController,
                          label: 'Message',
                          hint: 'Type your message here...',
                          maxLines: 6,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your message';
                            }
                            if (value.length < 10) {
                              return 'Message must be at least 10 characters';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 10.0),

                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _isSending ? null : _sendMessage,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: _isSending
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
                                      const Text('📤', style: TextStyle(fontSize: 20)),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'Send Message',
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
}
