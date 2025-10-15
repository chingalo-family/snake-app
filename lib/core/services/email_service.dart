import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:snake_app/core/constants/email_connection.dart';
import 'package:snake_app/core/models/email_notification.dart';

class EmailService {
  static sendEmail({required EmailNotification emailNotification}) async {
    final smtpServer = gmail(
      EmailConnection.senderEmail,
      EmailConnection.password,
    );
    final message = Message()
      ..from = const Address(
        EmailConnection.senderEmail,
        EmailConnection.senderName,
      )
      ..recipients.addAll(emailNotification.recipients!)
      ..ccRecipients.addAll(emailNotification.ccRecipients)
      ..subject = emailNotification.subject
      ..text = emailNotification.textBody;
    // ..html = emailNotification.htmlBody;
    try {
      final sendReport = await send(message, smtpServer);
      debugPrint('Message sent: $sendReport');
    } on MailerException catch (error) {
      debugPrint('Message not sent.');
      for (var problem in error.problems) {
        debugPrint('Problem: ${problem.code}: ${problem.msg}');
      }
    }
  }
}
