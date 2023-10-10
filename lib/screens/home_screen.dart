import 'package:apuntes/provider/home_provider.dart';
import 'package:apuntes/provider/sync_provider.dart';
import 'package:apuntes/widgets/custom_container.dart';
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

    final notesSync = ref.watch(getListProvider());

    if (notesSync.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (notesSync.hasError) {
      return const Scaffold(body: Center(child: Text('Error aqui')));
    }
    if (!notesSync.hasValue) {
      return const Scaffold(body: Center(child: Text('Error aqui')));
    }

    final color = Theme.of(context).colorScheme;

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
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            Text('Paginador'),
            Expanded(
                child: ListView.builder(
              itemCount: notesSync.value!.length,
              itemBuilder: (context, index) {
                final note = notesSync.value![index];

                return CustomContainer(
                  color: color.surfaceVariant,
                  borderVariant: BorderVariant.all,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Text(note.name),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ...note.coordenates
                              .map((String coordenate) => Text("$coordenate "))
                              .toList()
                        ],
                      )
                    ]),
                  ),
                );
              },
            )),
            const SizedBox(height: 70),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/note'),
          label: const Text('Nuevo elemento')),
    );
  }
}
