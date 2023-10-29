import 'package:encuestas_app/presentation/providers/providers.dart';
import "package:encuestas_app/presentation/screens/screens.dart";
import "package:encuestas_app/presentation/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

class SignUpScreen extends StatelessWidget {
  static const String name = 'signup_screen';

  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF648fe4),
      appBar: AppBar(
          backgroundColor: const Color(0xFF648fe4),
          iconTheme: const IconThemeData(color: Colors.white)),
      body: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatelessWidget {
  const _SignUpView();

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
              Text('¡Bienvenido!',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 42)),
              Text('Crea tu cuenta',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 24)),
            ],
          ),
        ),
        Expanded(
            child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(70),
          ),
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: const Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    children: [
                      _SignUpForm(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )),
      ],
    );
  }
}

class _SignUpForm extends ConsumerWidget {
  const _SignUpForm();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signupForm = ref.watch(signUpFormProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
      if (next.authStatus == AuthStatus.registred) {
        context.pushNamed(SignInScreen.name);
      }
    });

    return Form(
        child: Column(
      children: [
        CustomSurveyField(
          isTopField: true,
          isBottomField: true,
          label: 'Nombre de usuario',
          onChanged: ref.read(signUpFormProvider.notifier).onUsernameChanged,
          errorMessage:
              signupForm.isFormPosted ? signupForm.username.errorMessage : null,
        ),
        const SizedBox(
          height: 10,
        ),
        CustomSurveyField(
          isTopField: true,
          isBottomField: true,
          label: 'Correo electrónico',
          onChanged: ref.read(signUpFormProvider.notifier).onEmailChanged,
          errorMessage:
              signupForm.isFormPosted ? signupForm.email.errorMessage : null,
        ),
        const SizedBox(
          height: 10,
        ),
        CustomSurveyField(
          label: 'Contraseña',
          obscureText: true,
          isTopField: true,
          isBottomField: true,
          onChanged: ref.read(signUpFormProvider.notifier).onPasswordChanged,
          errorMessage:
              signupForm.isFormPosted ? signupForm.password.errorMessage : null,
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: signupForm.isPosting
                ? null
                : ref.read(signUpFormProvider.notifier).onFormSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF648fe4),
              foregroundColor: Colors.white,
            ),
            child: const Padding(
              padding: EdgeInsets.all(14),
              child: Text('Registrarse', style: TextStyle(fontSize: 18)),
            ),
          ),
        )
      ],
    ));
  }
}
