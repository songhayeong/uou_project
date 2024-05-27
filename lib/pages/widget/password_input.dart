import 'package:formz/formz.dart';

enum PasswordInputError { isEmpty, invalid }

class PasswordInput extends FormzInput<String, PasswordInputError> {
  const PasswordInput.pure() : super.pure('');

  const PasswordInput.dirty({String value = ''}) : super.dirty(value);

  @override
  PasswordInputError? validator(String value) {
    // 최소 8자 이상인지, 최소 하나의 대문자를 포함하는지, 최소 하나의 소문자를 포함하는지 , 하나의 숫자를 포함하는지, 최소 하나의 특수문자를 표현하는지
    bool hasMinLength = value.length >= 8;
    bool hasUpperCase = value.contains(RegExp(r'[A-Z]'));
    bool hasLowerCase = value.contains(RegExp(r'[a-z]'));
    bool hasDigit = value.contains(RegExp(r'\d'));
    bool hasSpecialCharacter =
    value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (value.isEmpty) return PasswordInputError.isEmpty;

    if (!hasMinLength ||
        !hasUpperCase ||
        !hasLowerCase ||
        !hasDigit ||
        !hasSpecialCharacter) {
      return PasswordInputError.invalid;
    }

    return null;
  }
}
