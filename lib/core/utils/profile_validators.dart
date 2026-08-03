/// Pure validators for the local player profile form.
abstract final class ProfileValidators {
  static final RegExp _usernamePattern = RegExp(r'^[a-zA-Z0-9_]+$');
  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _phoneDigitPattern = RegExp(r'^\+?[\d\s\-().]{7,20}$');

  static const int minUsernameLength = 2;
  static const int maxUsernameLength = 24;
  static const int minFullNameLength = 2;
  static const int maxFullNameLength = 60;
  static const int minPhoneDigits = 7;
  static const int maxPhoneDigits = 15;

  /// Required username: letters, numbers, underscore.
  static String? username(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'required';
    if (trimmed.length < minUsernameLength) return 'tooShort';
    if (trimmed.length > maxUsernameLength) return 'tooLong';
    if (!_usernamePattern.hasMatch(trimmed)) return 'invalid';
    return null;
  }

  /// Required display name.
  static String? fullName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'required';
    if (trimmed.length < minFullNameLength) return 'tooShort';
    if (trimmed.length > maxFullNameLength) return 'tooLong';
    return null;
  }

  /// Optional email - validated only when non-empty.
  static String? email(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null;
    if (!_emailPattern.hasMatch(trimmed)) return 'invalid';
    return null;
  }

  /// Optional phone - validated only when non-empty.
  /// Accepts common formats (+255 712 345 678, 0712345678, etc.).
  static String? phone(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null;
    if (!_phoneDigitPattern.hasMatch(trimmed)) return 'invalid';
    final digits = trimmed.replaceAll(RegExp(r'\D'), '');
    if (digits.length < minPhoneDigits || digits.length > maxPhoneDigits) {
      return 'invalid';
    }
    return null;
  }

  /// Digits-only normalized phone for storage, or null when empty.
  static String? normalizePhone(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null;
    final hasPlus = trimmed.startsWith('+');
    final digits = trimmed.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return null;
    return hasPlus ? '+$digits' : digits;
  }

  static String? normalizeEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }
}
