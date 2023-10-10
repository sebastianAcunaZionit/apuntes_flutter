import 'package:apuntes/datasource/user_datasource.dart';
import 'package:apuntes/entities/index.dart';
import 'package:apuntes/provider/auth_provider.dart';
import 'package:apuntes/provider/validations/string_form.dart';
import 'package:formz/formz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_form_provider.g.dart';

@riverpod
class AuthForm extends _$AuthForm {
  final userRepo = UserDatasource();

  @override
  AuthFormState build() {
    return AuthFormState();
  }

  onSubmit() async {
    state = state.copyWith(authFormStatus: AuthFormStatus.validating);

    _validate();

    if (!state.isFormValid) {
      state = state.copyWith(
          authFormStatus: AuthFormStatus.errored,
          errorMessage: "Debe ingresar un correo");
      return;
    }

    final user = await userRepo.getUserByEmail(state.email.value);
    if (user == null) {
      state = state.copyWith(
          authFormStatus: AuthFormStatus.errored,
          errorMessage: "Usuario no encontrado");
      return;
    }

    ref.read(authProvider.notifier).authenticate(user);
  }

  onChangeStatus(AuthFormStatus status) {
    state = state.copyWith(authFormStatus: status);
  }

  _validate() {
    state = state.copyWith(
      isFormValid: Formz.validate([StringInput.dirty(state.email.value)]),
    );
  }

  onEmailChange(String value) {
    state = state.copyWith(
      email: StringInput.dirty(value),
      errorMessage: "",
      authFormStatus: AuthFormStatus.none,
      isFormValid: Formz.validate([StringInput.dirty(value)]),
    );
  }
}

enum AuthFormStatus { none, validating, errored }

class AuthFormState {
  final StringInput email;
  final bool isFormValid;
  final String errorMessage;
  final AuthFormStatus authFormStatus;

  AuthFormState({
    this.email = const StringInput.pure(),
    this.isFormValid = false,
    this.errorMessage = "",
    this.authFormStatus = AuthFormStatus.none,
  });

  AuthFormState copyWith({
    StringInput? email,
    bool? isFormValid,
    String? errorMessage,
    AuthFormStatus? authFormStatus,
  }) =>
      AuthFormState(
        email: email ?? this.email,
        isFormValid: isFormValid ?? this.isFormValid,
        errorMessage: errorMessage ?? this.errorMessage,
        authFormStatus: authFormStatus ?? this.authFormStatus,
      );
}
