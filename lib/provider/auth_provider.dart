import 'package:apuntes/entities/index.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() {
    return AuthState();
  }

  authenticate(User user) {
    state = state.copyWith(authStatus: AuthStatus.authenticated);
  }
}

enum AuthStatus { none, authenticating, authenticated, notAuthenticated }

class AuthState {
  final User? user;
  final AuthStatus authStatus;
  final String errorMessage;
  final String token;

  AuthState({
    this.user,
    this.authStatus = AuthStatus.none,
    this.errorMessage = "",
    this.token = "",
  });

  AuthState copyWith({
    User? user,
    AuthStatus? authStatus,
    String? errorMessage,
    String? token,
  }) =>
      AuthState(
        user: user ?? this.user,
        authStatus: authStatus ?? this.authStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        token: token ?? this.token,
      );
}
