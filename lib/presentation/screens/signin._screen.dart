import 'package:encuestas_app/presentation/providers/providers.dart';
import "package:encuestas_app/presentation/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class SignInScreen extends StatelessWidget {
  static const String name = 'signin_screen';

  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF648fe4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF648fe4),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const _SignInView(),
    );
  }
}

class _SignInView extends StatelessWidget {
  const _SignInView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '!Hola!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                'Ingresa tu cuenta',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(70)),
            child: Container(
              color: Colors.white,
              width: double.infinity,
              child: const Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      children: [_SignInForm()],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _SignInForm extends ConsumerWidget {
  const _SignInForm();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signinForm = ref.watch(signInFormProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    return Form(
        child: Column(
      children: [
        CustomSurveyField(
          label: 'Correo electrónico',
          onChanged: ref.read(signInFormProvider.notifier).onEmailChanged,
          errorMessage:
              signinForm.isFormPosted ? signinForm.email.errorMessage : null,
          isTopField: true,
          isBottomField: true,
        ),
        const SizedBox(
          height: 10,
        ),
        CustomSurveyField(
          label: 'Contraseña',
          obscureText: true,
          onChanged: ref.read(signInFormProvider.notifier).onPasswordChanged,
          errorMessage:
              signinForm.isFormPosted ? signinForm.password.errorMessage : null,
          isBottomField: true,
          isTopField: true,
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              onPressed: signinForm.isPosting
                  ? null
                  : ref.read(signInFormProvider.notifier).onFormSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF648fe4),
                foregroundColor: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.all(14),
                child: Text('Iniciar Sesión', style: TextStyle(fontSize: 18)),
              )),
        )
      ],
    ));
  }
}
