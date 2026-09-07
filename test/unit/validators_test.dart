import 'package:flutter_test/flutter_test.dart';
import 'package:getx_architecture/core/utils/validators.dart';

import '../helpers/test_app.dart';

void main() {
  setUp(setUpTestApp);

  group('required', () {
    final validate = Validators.required();

    test('rejects null, empty and whitespace-only values', () {
      expect(validate(null), isNotNull);
      expect(validate(''), isNotNull);
      expect(validate('   '), isNotNull);
    });

    test('accepts any non-blank value', () {
      expect(validate('a'), isNull);
    });
  });

  group('email', () {
    final validate = Validators.email();

    test('accepts well-formed addresses', () {
      for (final value in ['a@b.co', 'first.last@sub.domain.org']) {
        expect(validate(value), isNull, reason: value);
      }
    });

    test('rejects malformed addresses', () {
      for (final value in ['a@b', 'a b@c.com', '@b.com', 'a@.com']) {
        expect(validate(value), isNotNull, reason: value);
      }
    });

    test('defers empty values to the required validator', () {
      expect(validate(''), isNull);
    });
  });

  group('password', () {
    final validate = Validators.password();

    test('requires length, a letter and a digit', () {
      expect(validate('short1'), isNotNull);
      expect(validate('alllettersonly'), isNotNull);
      expect(validate('12345678'), isNotNull);
      expect(validate('secret123'), isNull);
    });
  });

  group('phone', () {
    final validate = Validators.phone();

    test('ignores common separators', () {
      expect(validate('+880 (171) 234-5678'), isNull);
    });

    test('rejects letters and short numbers', () {
      expect(validate('12345'), isNotNull);
      expect(validate('01a2345678'), isNotNull);
    });
  });

  group('compose', () {
    test('returns the first failure and stops', () {
      final validate = Validators.compose([
        Validators.required(message: 'first'),
        Validators.email(message: 'second'),
      ]);

      expect(validate(''), 'first');
      expect(validate('nope'), 'second');
      expect(validate('a@b.co'), isNull);
    });
  });

  group('matches', () {
    test('compares against the latest value of the other field', () {
      var other = 'one';
      final validate = Validators.matches(() => other);

      expect(validate('one'), isNull);
      other = 'two';
      expect(validate('one'), isNotNull);
    });
  });

  group('minLength / maxLength', () {
    test('interpolates the bound into the message', () {
      expect(Validators.minLength(5)('abc'), contains('5'));
      expect(Validators.maxLength(3)('abcd'), contains('3'));
      expect(Validators.minLength(2)('abc'), isNull);
    });
  });
}
