import 'package:apuntes/provider/forms/note_form_provider.dart';
import 'package:apuntes/provider/location_provider.dart';
import 'package:apuntes/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class NoteScreen extends ConsumerStatefulWidget {
  const NoteScreen({super.key});

  @override
  NoteScreenState createState() => NoteScreenState();
}

class NoteScreenState extends ConsumerState<NoteScreen> {
  @override
  void initState() {
    super.initState();
    Future(() => ref.read(locationProvProvider.notifier).onCheckStatus());
    Future(() => ref.read(locationProvProvider.notifier).onLocationService());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    print("render note_screen");

    if (ref.watch(locationProvProvider).locationStatus ==
        LocationStatus.requesting) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (ref.watch(locationProvProvider).locationStatus !=
        LocationStatus.accepted) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No tiene los permisos para la ubicacion, por favor, aceptelos',
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: textStyle.titleLarge,
                ),
                const SizedBox(height: 20),
                FilledButton(
                    onPressed: () async {
                      if (ref.read(locationProvProvider).locationStatus ==
                          LocationStatus.denied) {
                        openAppSettings();
                        return;
                      }
                      Future(() => ref
                          .read(locationProvProvider.notifier)
                          .onRequestPermissions());
                    },
                    child: const Text('solicitar permisos')),
                const SizedBox(height: 10),
                TextButton(
                    onPressed: () => context.go('/'),
                    child: const Text('ir a inicio'))
              ],
            ),
          ),
        ),
      );
    }

    ref.listen(noteFormProvider, (previous, next) {
      if (next.status == NoteFormStatus.saved) {
        context.go('/');
      }
    });

    return WillPopScope(
      onWillPop: () async {
        if (ref.read(noteFormProvider).status != NoteFormStatus.none) {
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nuevo apunte'),
          actions: [
            TextButton(
              onPressed:
                  (ref.watch(noteFormProvider).status != NoteFormStatus.none)
                      ? null
                      : () => ref.read(noteFormProvider.notifier).onSubmit(),
              child: const Text('Guardar'),
            ),
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                CustomTextFormField(
                  color: colors.surfaceVariant,
                  label: 'Ingrese nombre',
                  prefixIcon: const Icon(Icons.person),
                  onChanged: (value) =>
                      ref.read(noteFormProvider.notifier).onChangeName(value),
                  errorMessage: ref.watch(noteFormProvider).name.errorMessage,
                ),
                const SizedBox(height: 40),
                CustomTextFormField(
                  label: 'Ingrese apunte',
                  color: colors.surfaceVariant,
                  maxLines: 15,
                  keyboardType: TextInputType.multiline,
                  onChanged: (value) =>
                      ref.read(noteFormProvider.notifier).onChangeNote(value),
                  errorMessage: ref.watch(noteFormProvider).note.errorMessage,
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
