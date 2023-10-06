import 'package:apuntes/provider/auth_provider.dart';
import 'package:apuntes/provider/forms/auth_form_provider.dart';
import 'package:apuntes/widgets/custom_container.dart';
import 'package:apuntes/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

    ref.listen(authProvider, (previous, next) {
      if (next.authStatus == AuthStatus.authenticated) {
        context.go('/');
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
                      : () => ref.read(authFormProvider.notifier).onSubmit(),
                  child: const Text('descargar usuarios'),
                ),
                const SizedBox(height: 35),
                Text("Powered by Zionit",
                    style: TextStyle(color: colors.secondaryContainer))
              ],
            ),
          ),
        ),
      )),
    );
  }
}
