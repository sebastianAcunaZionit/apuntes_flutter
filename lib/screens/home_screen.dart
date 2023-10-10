import 'package:apuntes/config/router/app_router.dart';
import 'package:apuntes/provider/forms/note_form_provider.dart';
import 'package:apuntes/provider/home_provider.dart';
import 'package:apuntes/provider/note_provider.dart';
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
    final textStyle = Theme.of(context).textTheme;

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
                ref.read(appRouterProvider).go('/login');
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

                String dato =
                    "aalskmdalksasdasdjknaskcjnakjsnckajsnckajnckajnckjasnckajsnckajsnckjasnckajsnc12312312312141231241234123dascascasawdawsacasc";

                dato = (index % 2 == 0) ? note.note : dato;

                return CustomContainer(
                  color: color.surfaceVariant,
                  borderVariant: BorderVariant.all,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                note.name,
                                style: textStyle.titleMedium,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child:
                                    Text(dato, overflow: TextOverflow.ellipsis),
                              ),
                              if (dato.length > 100) ...[
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.expand_more))
                              ]
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    ref.invalidate(noteFormProvider);
                                    ref.invalidate(noteProvProvider);
                                    ref
                                        .read(appRouterProvider)
                                        .push('/note/${note.id}');
                                  },
                                  child: const Text('EDITAR'))
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
          onPressed: () {
            ref.invalidate(noteFormProvider);
            ref.invalidate(noteProvProvider);
            ref.read(appRouterProvider).push('/note/new');
          },
          label: const Text('Nuevo elemento')),
    );
  }
}
