import 'package:formz/formz.dart';

enum EmailInputError { empty, invalid }

final emailRegExp = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-z0-9]+\.[a-zA-Z]+');

class EmailInput extends FormzInput<String, EmailInputError> {

  const EmailInput.pure() : super.pure(''); // initial value

  const EmailInput.dirty({String value = ''}) : super.dirty(value); // 값이 들어와서 validator가 trigger된 상태를 의미

  @override
  EmailInputError? validator(String value) {
    if (value.isEmpty) {
      return EmailInputError.empty;
    }
    return !emailRegExp.hasMatch(value) ? EmailInputError.invalid : null;
  }

}