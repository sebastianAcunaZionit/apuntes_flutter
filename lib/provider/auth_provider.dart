import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:apuntes/config/configs.dart';
import 'package:apuntes/datasource/datasources.dart';
import 'package:apuntes/entities/entities.dart';
import 'package:apuntes/services/services.dart';
part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  final keyValueStorageService = KeyValueStorageServiceImpl();
  final userRepo = UserDatasource();

  @override
  AuthState build() {
    return AuthState();
  }

  authenticate(User user) async {
    final token = Jwt.sign(
        {'username': user.userName, 'fullName': user.fullName, 'uid': user.id});

    await keyValueStorageService.setKeyValue(Environment.tokenName, token);
    state = state.copyWith();
    Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(
      user: user,
      token: token,
      authStatus: AuthStatus.authenticated,
    );
  }

  checkAuthStatus() async {
    // state = state.copyWith(authStatus: AuthStatus.authenticating);
    await Future.delayed(const Duration(seconds: 2));
    final token =
        await keyValueStorageService.getValue<String>(Environment.tokenName);
    final tokenData = Jwt.verify(token ?? '');

    if (!tokenData["ok"]) {
      removeToken();
      return;
    }

    final user = await userRepo.getUserById(tokenData["payload"]["uid"]);
    if (user == null) {
      removeToken();
      return;
    }

    state = state.copyWith(
        authStatus: AuthStatus.authenticated, user: user, token: token);

    return;
  }

  void logout() {
    removeToken();
  }

  void removeToken() async {
    await keyValueStorageService.removeKey(Environment.tokenName);
    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      token: null,
      user: null,
    );
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
