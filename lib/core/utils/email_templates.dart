import 'package:snake_app/core/constants/app_info_reference.dart';

class EmailTemplates {
  /// Helper method to get app color as hex string
  static String _getAppColorHex() {
    return '#${AppInfoReference.defaultAppColor.value.toRadixString(16).substring(2)}';
  }

  /// Generates HTML email template with app branding
  static String _getEmailTemplate({
    required String title,
    required String content,
    String? footerText,
  }) {
    final appColor = _getAppColorHex();
    
    return '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$title</title>
</head>
<body style="margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; background-color: #f5f5f5;">
    <table role="presentation" style="width: 100%; border-collapse: collapse;">
        <tr>
            <td align="center" style="padding: 40px 0;">
                <table role="presentation" style="width: 600px; max-width: 100%; border-collapse: collapse; background-color: #ffffff; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                    <!-- Header -->
                    <tr>
                        <td style="padding: 40px 40px 20px; text-align: center; background: linear-gradient(135deg, $appColor 0%, rgba($appColor, 0.7) 100%); border-radius: 12px 12px 0 0;">
                            <div style="font-size: 40px; margin-bottom: 10px;">🐍</div>
                            <h1 style="margin: 0; color: #ffffff; font-size: 28px; font-weight: 700;">${AppInfoReference.appName}</h1>
                            <p style="margin: 8px 0 0; color: rgba(255,255,255,0.9); font-size: 14px;">Classic Arcade Snake Game</p>
                        </td>
                    </tr>
                    
                    <!-- Content -->
                    <tr>
                        <td style="padding: 40px;">
                            $content
                        </td>
                    </tr>
                    
                    <!-- Footer -->
                    <tr>
                        <td style="padding: 30px 40px; background-color: #f9f9f9; border-radius: 0 0 12px 12px; text-align: center;">
                            <p style="margin: 0 0 10px; color: #666666; font-size: 14px;">${footerText ?? 'Play. Compete. Enjoy!'}</p>
                            <p style="margin: 0; color: #999999; font-size: 12px;">
                                © ${DateTime.now().year} ${AppInfoReference.appName} - Version ${AppInfoReference.currentAppVersion}
                            </p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>
''';
  }

  /// Contact form submission email to admins
  static String getContactFormEmail({
    required String category,
    required String subject,
    required String message,
    required String senderEmail,
  }) {
    final appColor = _getAppColorHex();
    
    final content = '''
<h2 style="margin: 0 0 24px; color: #333333; font-size: 24px; font-weight: 600;">New Contact Form Submission</h2>

<div style="background-color: #f5f5f5; border-left: 4px solid $appColor; padding: 20px; margin-bottom: 24px; border-radius: 4px;">
    <p style="margin: 0 0 12px; color: #666666; font-size: 14px;"><strong>Category:</strong></p>
    <p style="margin: 0; color: #333333; font-size: 16px;">$category</p>
</div>

<div style="background-color: #f5f5f5; border-left: 4px solid $appColor; padding: 20px; margin-bottom: 24px; border-radius: 4px;">
    <p style="margin: 0 0 12px; color: #666666; font-size: 14px;"><strong>Subject:</strong></p>
    <p style="margin: 0; color: #333333; font-size: 16px;">$subject</p>
</div>

<div style="background-color: #f5f5f5; border-left: 4px solid $appColor; padding: 20px; margin-bottom: 24px; border-radius: 4px;">
    <p style="margin: 0 0 12px; color: #666666; font-size: 14px;"><strong>Message:</strong></p>
    <p style="margin: 0; color: #333333; font-size: 16px; line-height: 1.6; white-space: pre-wrap;">$message</p>
</div>

<div style="padding: 20px; background-color: #fef9e7; border-radius: 4px; margin-top: 24px;">
    <p style="margin: 0; color: #666666; font-size: 14px;">
        <strong>Reply to:</strong> <a href="mailto:$senderEmail" style="color: $appColor; text-decoration: none;">$senderEmail</a>
    </p>
</div>
''';

    return _getEmailTemplate(
      title: 'New Contact Form Submission',
      content: content,
      footerText: 'This message was sent from ${AppInfoReference.appName} contact form',
    );
  }

  /// Welcome email to new user
  static String getWelcomeEmail({
    required String username,
    required String fullName,
  }) {
    final appColor = _getAppColorHex();
    
    final content = '''
<h2 style="margin: 0 0 16px; color: #333333; font-size: 26px; font-weight: 600;">Welcome to ${AppInfoReference.appName}! 🎉</h2>

<p style="margin: 0 0 20px; color: #666666; font-size: 16px; line-height: 1.6;">
    Hi <strong>$fullName</strong>,
</p>

<p style="margin: 0 0 24px; color: #666666; font-size: 16px; line-height: 1.6;">
    Thank you for joining ${AppInfoReference.appName}! Your account has been successfully created, and you're now ready to start playing and competing with players worldwide.
</p>

<div style="background: linear-gradient(135deg, $appColor 0%, rgba($appColor, 0.8) 100%); padding: 24px; border-radius: 8px; margin: 24px 0;">
    <h3 style="margin: 0 0 16px; color: #ffffff; font-size: 20px; font-weight: 600;">Your Account Details</h3>
    <p style="margin: 0; color: rgba(255,255,255,0.95); font-size: 15px;">
        <strong>Username:</strong> $username
    </p>
</div>

<h3 style="margin: 32px 0 16px; color: #333333; font-size: 20px; font-weight: 600;">🎮 Get Started</h3>

<div style="margin-bottom: 16px;">
    <div style="padding: 16px; background-color: #f9f9f9; border-radius: 6px; margin-bottom: 12px;">
        <div style="display: inline-block; width: 32px; height: 32px; line-height: 32px; text-align: center; font-size: 18px; margin-right: 12px;">🏆</div>
        <div style="display: inline-block; vertical-align: top;">
            <strong style="color: #333333; font-size: 16px;">Compete Globally</strong>
            <p style="margin: 4px 0 0; color: #666666; font-size: 14px;">Climb the leaderboard and prove you're the best snake player!</p>
        </div>
    </div>

    <div style="padding: 16px; background-color: #f9f9f9; border-radius: 6px; margin-bottom: 12px;">
        <div style="display: inline-block; width: 32px; height: 32px; line-height: 32px; text-align: center; font-size: 18px; margin-right: 12px;">⚡</div>
        <div style="display: inline-block; vertical-align: top;">
            <strong style="color: #333333; font-size: 16px;">Power-Ups & Combos</strong>
            <p style="margin: 4px 0 0; color: #666666; font-size: 14px;">Collect power-ups and build combos for massive score multipliers!</p>
        </div>
    </div>

    <div style="padding: 16px; background-color: #f9f9f9; border-radius: 6px;">
        <div style="display: inline-block; width: 32px; height: 32px; line-height: 32px; text-align: center; font-size: 18px; margin-right: 12px;">📊</div>
        <div style="display: inline-block; vertical-align: top;">
            <strong style="color: #333333; font-size: 16px;">Track Your Progress</strong>
            <p style="margin: 4px 0 0; color: #666666; font-size: 14px;">View detailed statistics and watch your skills improve over time!</p>
        </div>
    </div>
</div>

<div style="text-align: center; margin: 32px 0;">
    <a href="#" style="display: inline-block; padding: 14px 32px; background-color: $appColor; color: #ffffff; text-decoration: none; border-radius: 6px; font-weight: 600; font-size: 16px;">Start Playing Now</a>
</div>

<p style="margin: 24px 0 0; color: #666666; font-size: 15px; line-height: 1.6;">
    Need help? Feel free to reach out to us anytime. We're here to ensure you have the best gaming experience!
</p>
''';

    return _getEmailTemplate(
      title: 'Welcome to ${AppInfoReference.appName}',
      content: content,
    );
  }

  /// New signup notification to admins
  static String getNewSignupNotificationEmail({
    required String username,
    required String fullName,
    required String email,
  }) {
    final appColor = _getAppColorHex();
    
    final content = '''
<h2 style="margin: 0 0 24px; color: #333333; font-size: 24px; font-weight: 600;">New User Registration 🎉</h2>

<p style="margin: 0 0 24px; color: #666666; font-size: 16px; line-height: 1.6;">
    A new user has successfully registered on ${AppInfoReference.appName}!
</p>

<div style="background-color: #f5f5f5; border-left: 4px solid $appColor; padding: 20px; margin-bottom: 16px; border-radius: 4px;">
    <p style="margin: 0 0 8px; color: #666666; font-size: 14px;"><strong>Full Name:</strong></p>
    <p style="margin: 0; color: #333333; font-size: 16px;">$fullName</p>
</div>

<div style="background-color: #f5f5f5; border-left: 4px solid $appColor; padding: 20px; margin-bottom: 16px; border-radius: 4px;">
    <p style="margin: 0 0 8px; color: #666666; font-size: 14px;"><strong>Username:</strong></p>
    <p style="margin: 0; color: #333333; font-size: 16px;">$username</p>
</div>

<div style="background-color: #f5f5f5; border-left: 4px solid $appColor; padding: 20px; margin-bottom: 24px; border-radius: 4px;">
    <p style="margin: 0 0 8px; color: #666666; font-size: 14px;"><strong>Email:</strong></p>
    <p style="margin: 0; color: #333333; font-size: 16px;">
        <a href="mailto:$email" style="color: $appColor; text-decoration: none;">$email</a>
    </p>
</div>

<div style="padding: 20px; background-color: #e8f5e9; border-radius: 4px; margin-top: 24px;">
    <p style="margin: 0; color: #2e7d32; font-size: 14px;">
        <strong>Registration Time:</strong> ${DateTime.now().toString().substring(0, 19)}
    </p>
</div>
''';

    return _getEmailTemplate(
      title: 'New User Registration',
      content: content,
      footerText: 'Admin notification from ${AppInfoReference.appName}',
    );
  }
}
