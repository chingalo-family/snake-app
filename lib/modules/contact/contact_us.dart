import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snake_app/core/components/app_bar_container.dart';
import 'package:snake_app/core/components/material_card.dart';
import 'package:snake_app/core/constants/email_connection.dart';
import 'package:snake_app/core/models/email_notification.dart';
import 'package:snake_app/core/services/email_service.dart';
import 'package:snake_app/core/utils/email_templates.dart';
import 'package:snake_app/modules/contact/components/category_dropdown_field.dart';
import 'package:snake_app/modules/contact/components/contact_header.dart';
import 'package:snake_app/modules/contact/components/contact_info_section.dart';
import 'package:snake_app/modules/contact/components/labeled_text_field.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSending = false;
  String _selectedCategory = 'General Inquiry';

  @override
  void dispose() {
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
        final htmlBody = EmailTemplates.getContactFormEmail(
          category: _selectedCategory,
          subject: _subjectController.text,
          message: _messageController.text,
          senderEmail: EmailConnection.senderEmail,
        );

        final emailNotification = EmailNotification(
          recipients: [EmailConnection.senderEmail],
          subject: '[$_selectedCategory] ${_subjectController.text}',
          textBody:
              '''
Category: $_selectedCategory
Subject: ${_subjectController.text}

Message:
${_messageController.text}
''',
          htmlBody: htmlBody,
        );

        await EmailService.sendEmail(emailNotification: emailNotification);

        if (mounted) {
          Fluttertoast.showToast(
            msg: "Message sent successfully!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
          );

          // Clear form
          _subjectController.clear();
          _messageController.clear();
          setState(() {
            _selectedCategory = 'General Inquiry';
          });

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
              // Get in Touch Header
              MaterialCard(
                elevation: 2.0,
                borderRadius: 16.0,
                body: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  child: const ContactHeader(
                    title: 'Get in Touch',
                    subtitle: 'We\'d love to hear from you',
                  ),
                ),
              ),

              const SizedBox(height: 24.0),

              // Contact Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Dropdown
                    CategoryDropdownField(
                      value: _selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),

                    // Subject
                    LabeledTextField(
                      label: 'Subject',
                      controller: _subjectController,
                      hint: 'Brief description of your inquiry',
                      prefixIcon: Icon(
                        Icons.subject_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a subject';
                        }
                        return null;
                      },
                    ),

                    // Message
                    LabeledTextField(
                      label: 'Message',
                      controller: _messageController,
                      hint: 'Tell us more about your inquiry...',
                      maxLines: 6,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 80.0),
                        child: Icon(
                          Icons.message_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
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

                    const SizedBox(height: 8.0),

                    // Send Button
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
                            : Text(
                                'Send Message',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24.0),

              // Other Ways to Reach Us
              MaterialCard(
                elevation: 2.0,
                borderRadius: 16.0,
                body: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  child: ContactInfoSection(
                    email: EmailConnection.senderEmail,
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
