import 'package:apuntes/config/router/app_router.dart';
import 'package:apuntes/provider/forms/note_form_provider.dart';
import 'package:apuntes/provider/home_provider.dart';
import 'package:apuntes/provider/note_provider.dart';
import 'package:apuntes/provider/sync_provider.dart';
import 'package:apuntes/widgets/custom_text_form_field.dart';
import 'package:apuntes/widgets/note_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:badges/badges.dart' as badges;

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

    final notesSync = ref.watch(homeProvProvider);

    if (notesSync.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (notesSync.hasError) {
      return const Scaffold(body: Center(child: Text('Error aqui')));
    }
    if (!notesSync.hasValue) {
      return const Scaffold(body: Center(child: Text('Error aqui')));
    }

    final page = notesSync.value!.page;
    final total = notesSync.value!.total;
    final notes = notesSync.value!.notes;
    final filter = notesSync.value!.filter ?? "";

    final color = Theme.of(context).colorScheme;

    void setFilter(String filter) {
      ref.read(homeProvProvider.notifier).getFilter(filter);
      ref.read(appRouterProvider).pop();
    }

    void showDialogFilter() {
      final filterController = TextEditingController();
      filterController.text = filter;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('filtro'),
              content: CustomTextFormField(
                controller: filterController,
                label: 'nombre',
                color: color.surfaceVariant,
                onTap: () {
                  filterController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: filterController.text.length);
                },
              ),
              actions: [
                TextButton(
                    onPressed: () => ref.read(appRouterProvider).pop(),
                    child: const Text('cancelar')),
                TextButton(
                    onPressed: () => setFilter(filterController.text),
                    child: const Text('Guardar'))
              ],
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/icons/notes-icon.png',
            height: 10,
            width: 10,
            fit: BoxFit.contain,
          ),
        ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pagina $page de ${(total == 0 ? 1 : total)}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      badges.Badge(
                        showBadge: (filter.isNotEmpty),
                        badgeContent: const Text("1"),
                        child: IconButton(
                          onPressed: () {
                            showDialogFilter();
                          },
                          icon: const Icon(Icons.filter_alt),
                          color: color.primary,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return NoteItem(note: note);
              },
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton.filled(
                    onPressed: (page == 1)
                        ? null
                        : () {
                            ref
                                .read(homeProvProvider.notifier)
                                .changePage(page - 1);
                          },
                    icon: const Icon(Icons.keyboard_arrow_left_outlined),
                  ),
                  IconButton.filled(
                    onPressed: (page >= (total))
                        ? null
                        : () {
                            ref
                                .read(homeProvProvider.notifier)
                                .changePage(page + 1);
                          },
                    icon: const Icon(Icons.keyboard_arrow_right_outlined),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.invalidate(noteFormProvider);
          ref.invalidate(noteProvProvider);
          ref.read(appRouterProvider).push('/note/new');
        },
        label: const Text('Nuevo apunte'),
        icon: const Icon(Icons.note),
      ),
    );
  }
}
