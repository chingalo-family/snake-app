import 'package:flutter_test/flutter_test.dart';
import 'package:snake_app/core/utils/profile_validators.dart';

void main() {
  group('ProfileValidators.username', () {
    test('rejects empty and short values', () {
      expect(ProfileValidators.username(null), 'required');
      expect(ProfileValidators.username(''), 'required');
      expect(ProfileValidators.username('a'), 'tooShort');
    });

    test('rejects invalid characters and overly long values', () {
      expect(ProfileValidators.username('bad name'), 'invalid');
      expect(ProfileValidators.username('ok-name'), 'invalid');
      expect(ProfileValidators.username('a' * 25), 'tooLong');
    });

    test('accepts valid usernames', () {
      expect(ProfileValidators.username('maya'), isNull);
      expect(ProfileValidators.username('Maya_01'), isNull);
    });
  });

  group('ProfileValidators.fullName', () {
    test('requires a real name', () {
      expect(ProfileValidators.fullName(''), 'required');
      expect(ProfileValidators.fullName('A'), 'tooShort');
      expect(ProfileValidators.fullName('Maya Chingalo'), isNull);
    });
  });

  group('ProfileValidators.email', () {
    test('allows empty and validates format when set', () {
      expect(ProfileValidators.email(''), isNull);
      expect(ProfileValidators.email('not-an-email'), 'invalid');
      expect(ProfileValidators.email('maya@example.com'), isNull);
    });
  });

  group('ProfileValidators.phone', () {
    test('allows empty and validates digit length when set', () {
      expect(ProfileValidators.phone(''), isNull);
      expect(ProfileValidators.phone('123'), 'invalid');
      expect(ProfileValidators.phone('abc'), 'invalid');
      expect(ProfileValidators.phone('+255712345678'), isNull);
      expect(ProfileValidators.phone('0712 345 678'), isNull);
    });

    test('normalizePhone keeps leading plus', () {
      expect(ProfileValidators.normalizePhone('+255 712 345 678'), '+255712345678');
      expect(ProfileValidators.normalizePhone('0712345678'), '0712345678');
      expect(ProfileValidators.normalizePhone('  '), isNull);
    });
  });
}
