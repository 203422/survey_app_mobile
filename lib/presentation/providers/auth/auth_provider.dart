import 'package:encuestas_app/auth/auth_errors.dart';
import 'package:encuestas_app/auth/auth_user.dart';
import 'package:encuestas_app/auth/key_value_storage.dart';
import 'package:encuestas_app/auth/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { checking, authenticated, notAuthenticated, registred }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;
  final List? users;

  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.user,
      this.errorMessage = '',
      this.users});

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
    List? users,
  }) =>
      AuthState(
        authStatus: authStatus ?? this.authStatus,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
        users: users ?? this.users,
      );
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthUser authUser;
  final KeyValueStorage keyValueStorage;

  AuthNotifier({required this.authUser, required this.keyValueStorage})
      : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> signinUser(String email, String password) async {
    try {
      final user = await authUser.signin(email, password);
      _setLoggedUser(user);
    } on CustomError catch (error) {
      logout(error.message);
    } catch (error) {
      logout('Ocurrió un error');
    }
  }

  Future<void> signUpUser(
      String username, String email, String password) async {
    try {
      final newUser = await authUser.signup(username, email, password);
      state = state.copyWith(
        errorMessage: newUser,
        authStatus: AuthStatus.registred,
      );
    } on CustomError catch (error) {
      logout(error.message);
    } catch (error) {
      logout('Ocurrio un error');
    }
  }

  Future getUsers() async {
    try {
      final users = await authUser.getAllUsers(state.user!.token);
      state = state.copyWith(
        users: users,
      );
    } on CustomError catch (error) {
      logout(error.message);
    } catch (error) {
      throw Exception(error);
    }
  }

  void checkAuthStatus() async {
    final token = await keyValueStorage.getValue<String>('token');
    if (token == null) return logout();

    try {
      final user = await authUser.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (error) {
      logout();
    }
  }

  void _setLoggedUser(User user) async {
    await keyValueStorage.setKeyValue('token', user.token);
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  Future<void> logout([String? errorMessage]) async {
    await keyValueStorage.removeKey('token');

    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage,
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authUser = AuthUser();
  final keyValueStorage = KeyValueStorage();
  return AuthNotifier(authUser: authUser, keyValueStorage: keyValueStorage);
});
