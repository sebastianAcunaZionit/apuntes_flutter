import 'package:apuntes/provider/auth_provider.dart';
import 'package:apuntes/screens/auth_screen.dart';
import 'package:apuntes/screens/home_screen.dart';
import 'package:apuntes/screens/note_screen.dart';
import 'package:apuntes/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final authProv = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
          path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
          path: '/note/:uid',
          builder: (context, state) =>
              NoteScreen(uid: state.pathParameters['uid'] ?? 'new')),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen())
    ],
    redirect: (context, state) {
      final isGointTo = state.matchedLocation;

      if (authProv.authStatus == AuthStatus.notAuthenticated) {
        return '/login';
      }

      if (isGointTo == '/splash') {
        if (authProv.authStatus == AuthStatus.notAuthenticated) return '/login';
        if (authProv.authStatus == AuthStatus.authenticated) return '/';
      }

      return null;
    },
  );
}
