import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apuntes/provider/providers.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    Future(() => ref.read(locationProvProvider.notifier).onCheckStatus());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future(() => ref.read(authProvider.notifier).checkAuthStatus());
    print("render splash");
    return Scaffold(
        body: Center(
            child: Lottie.asset('assets/lotties/loading.json',
                fit: BoxFit.cover, height: 250, repeat: true, animate: true)));
  }
}
