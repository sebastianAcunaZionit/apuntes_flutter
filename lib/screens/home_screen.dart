import 'package:apuntes/provider/sync_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final isSyncing =
        (ref.watch(syncProvProvider).syncStatus == SyncStatus.uploading ||
            ref.watch(syncProvProvider).syncStatus == SyncStatus.downloading);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text('apuntes'),
        actions: [
          IconButton(
              onPressed: isSyncing ||
                      ref.watch(syncProvProvider).syncStatus ==
                          SyncStatus.uploaded
                  ? null
                  : () {
                      ref.read(syncProvProvider.notifier).startUpload();
                    },
              icon: isSyncing
                  ? const CircularProgressIndicator()
                  : (ref.watch(syncProvProvider).syncStatus ==
                          SyncStatus.uploaded)
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const Text("Sincronizar")),
          IconButton(
              onPressed: () {
                context.go('/login');
              },
              icon: const Icon(Icons.logout_outlined)),
        ],
      ),
      body: const SafeArea(
          child: Center(
        child: Text('sin registros'),
      )),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/note'),
          label: const Text('Nuevo elemento')),
    );
  }
}
