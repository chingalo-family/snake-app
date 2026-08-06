
abstract final class ProfileValidators {
  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _phoneDigitPattern = RegExp(r'^\+?[\d\s\-().]{7,20}$');

  static const int minNameLength = 2;
  static const int maxNameLength = 60;
  static const int minPhoneDigits = 7;
  static const int maxPhoneDigits = 15;

  
  static String? name(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'required';
    if (trimmed.length < minNameLength) return 'tooShort';
    if (trimmed.length > maxNameLength) return 'tooLong';
    return null;
  }

  
  static String? email(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null;
    if (!_emailPattern.hasMatch(trimmed)) return 'invalid';
    return null;
  }

  
  
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
