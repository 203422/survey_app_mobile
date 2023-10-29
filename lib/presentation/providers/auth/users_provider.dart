import 'package:encuestas_app/auth/auth_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_app/presentation/providers/providers.dart';

class UsersState {
  final String message;
  final bool isLoading;
  final List? users;

  UsersState({this.message = '', this.isLoading = true, this.users});

  UsersState copyWith({
    String? message,
    bool? isLoading,
    List? users,
  }) =>
      UsersState(
        message: message ?? this.message,
        isLoading: isLoading ?? this.isLoading,
        users: users ?? this.users,
      );
}

class AuthNotifier extends StateNotifier<UsersState> {
  final AuthUser authUser;
  final String token;

  AuthNotifier({required this.authUser, required this.token})
      : super(UsersState()) {
    getUsers();
  }

  Future getUsers() async {
    try {
      final users = await authUser.getAllUsers(token);
      state = state.copyWith(
        isLoading: false,
        users: users,
      );
    } catch (error) {
      throw Exception(error);
    }
  }
}

final usersProvider = StateNotifierProvider<AuthNotifier, UsersState>((ref) {
  final authUser = AuthUser();
  final token = ref.watch(authProvider).user?.token;
  return AuthNotifier(authUser: authUser, token: token!);
});
