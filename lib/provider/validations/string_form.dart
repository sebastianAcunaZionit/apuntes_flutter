import 'package:formz/formz.dart';

enum StringInputError { empty, length }

class StringInput extends FormzInput<String, StringInputError> {
  const StringInput.pure() : super.pure("");
  const StringInput.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == StringInputError.empty) return 'El campo es requerido';
    if (displayError == StringInputError.length) {
      return 'Debe tener al menos 3 caracteres';
    }

    return null;
  }

  @override
  StringInputError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return StringInputError.empty;
    }
    if (value.length < 3) {
      return StringInputError.length;
    }

    return null;
  }
}
