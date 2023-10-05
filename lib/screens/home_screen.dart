import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
          child: Center(
        child: Text('sin registros'),
      )),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/new'),
          label: const Text('Nuevo elemento')),
    );
  }
}
