import 'package:apuntes/screens/auth_screen.dart';
import 'package:apuntes/screens/home_screen.dart';
import 'package:apuntes/screens/new_note.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/new', builder: (context, state) => const NoteScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen())
  ],
);
