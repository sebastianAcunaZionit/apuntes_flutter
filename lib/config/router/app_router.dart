import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:apuntes/provider/providers.dart';
import 'package:apuntes/screens/screens.dart';

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
      print(authProv.authStatus);
      print(isGointTo);

      if (isGointTo == '/splash') {
        if (authProv.authStatus == AuthStatus.authenticated) return '/';
      }

      if (authProv.authStatus == AuthStatus.notAuthenticated) {
        return '/login';
      }

      return null;
    },
  );
}
