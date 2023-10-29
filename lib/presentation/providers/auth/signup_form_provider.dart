import 'package:encuestas_app/infrastructure/inputs/inputs.dart';
import 'package:encuestas_app/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

//Crear el estado
class SignUpFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Username username;
  final Email email;
  final Password password;

  SignUpFormState({
    this.isPosting = false, 
    this.isFormPosted  = false, 
    this.isValid = false, 
    this.username = const Username.pure(), 
    this.email = const Email.pure(), 
    this.password = const Password.pure()
    }
  );

  SignUpFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Username? username,
    Email? email,
    Password? password,
  }) => SignUpFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    username: username ?? this.username,
    email: email ?? this.email,
    password: password ?? this.password,    
  );

  @override
  String toString() {
    return '''

  SignUpFormState:
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    username: $username
    email: $email
    password: $password

    ''';
  }
}

// Implementación nofitifer (Manejador)

class SignUpFormNotifier extends StateNotifier<SignUpFormState> { 

  final Function(String, String, String) signUpCallback;


  SignUpFormNotifier({required this.signUpCallback}): super( SignUpFormState() );

  onUsernameChanged(String value) {
    final newUserName = Username.dirty(value);
    state = state.copyWith(
      username: newUserName,
      isValid: Formz.validate([newUserName, state.email, state.password])
    );
  }

  onEmailChanged(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.username, state.password])
    );
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.username, state.email])
    );
  }

  onFormSubmit() async {  
    _touchEveryField();
    if(!state.isValid) return;
    state = state.copyWith(isPosting: true);

    await signUpCallback(state.username.value, state.email.value, state.password.value);
    state = state.copyWith(isPosting: false);

  }

  _touchEveryField() {
    final username = Username.dirty(state.username.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true,
      username: username,
      email: email,
      password: password,
      isValid: Formz.validate([username, email, password])
    ); 
  }
}

// StateNotifierProvider - consume afuera
final signUpFormProvider = StateNotifierProvider.autoDispose<SignUpFormNotifier, SignUpFormState>((ref) {
  final signUpCallback = ref.watch(authProvider.notifier).signUpUser;
  return SignUpFormNotifier(signUpCallback: signUpCallback);
});