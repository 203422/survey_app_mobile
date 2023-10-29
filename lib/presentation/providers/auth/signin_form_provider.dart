import 'package:encuestas_app/infrastructure/inputs/inputs.dart';
import 'package:encuestas_app/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

class SignInFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  SignInFormState({
    this.isPosting = false, 
    this.isFormPosted  = false, 
    this.isValid  = false, 
    this.email = const Email.pure(), 
    this.password = const Password.pure()
  });

  SignInFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) => SignInFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    email: email ?? this.email,
    password: password ?? this.password,
  );

  @override
  String toString() {
    return '''

  LoginFormState:
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    email: $email
    password: $password

    ''';
  }
}

// Como implementar un notifier (Manejador)

class SigninFormNotifier extends StateNotifier<SignInFormState> {

  final Function(String, String) signinUserCallback;

  SigninFormNotifier({required this.signinUserCallback}): super( SignInFormState() );

  onEmailChanged(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password])
    );
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.email])
    );
  }

  onFormSubmit() async{
    _touchEveryField(); 
    if(!state.isValid) return;
    state = state.copyWith(isPosting: true);
    await signinUserCallback(state.email.value, state.password.value);
    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      isValid: Formz.validate([email, password])
    );
  }
}


// StateNotifierProvider - consume afuera

final signInFormProvider = StateNotifierProvider.autoDispose<SigninFormNotifier, SignInFormState>((ref) {

  final signinUserCallback = ref.watch(authProvider.notifier).signinUser;

  return SigninFormNotifier(signinUserCallback: signinUserCallback);
}); 