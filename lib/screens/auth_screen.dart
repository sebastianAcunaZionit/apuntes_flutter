import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apuntes/provider/providers.dart';
import 'package:apuntes/widgets/widgets.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authFormProvider, (previous, next) {
      if (next.authFormStatus == AuthFormStatus.errored) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.errorMessage)));
      }
    });
    ref.listen(syncProvProvider, (previous, next) {
      if (next.syncStatus == SyncStatus.errored) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.errorMessage)));
      }

      if (next.syncStatus == SyncStatus.donwloaded) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Usuarios descargados con exito")));
      }
    });

    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: CustomContainer(
          margin: const EdgeInsets.all(15),
          // color: colors.primaryContainer,
          borderVariant: BorderVariant.all,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CustomTextFormField(
                    color: colors.surfaceVariant,
                    label: 'correo',
                    onChanged: (value) => ref
                        .read(authFormProvider.notifier)
                        .onEmailChange(value),
                    errorMessage:
                        ref.watch(authFormProvider).email.errorMessage,
                    suffixIcon: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.all(15))),
                            onPressed:
                                ref.watch(authFormProvider).authFormStatus ==
                                        AuthFormStatus.validating
                                    ? null
                                    : () => ref
                                        .read(authFormProvider.notifier)
                                        .onSubmit(),
                            child: const Text("Iniciar Sesión")),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: ref.watch(authFormProvider).authFormStatus ==
                          AuthFormStatus.validating
                      ? null
                      : () =>
                          ref.read(syncProvProvider.notifier).startDownload(),
                  child: const Text('descargar usuarios'),
                ),
                if (ref.watch(syncProvProvider).syncStatus ==
                    SyncStatus.downloading) ...[
                  const SizedBox(height: 10),
                  const CircularProgressIndicator(),
                ],
                const SizedBox(height: 35),
                Text("Powered by ZionIT",
                    style: TextStyle(color: colors.secondaryContainer))
              ],
            ),
          ),
        ),
      )),
    );
  }
}
