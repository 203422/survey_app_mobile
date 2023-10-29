import 'package:encuestas_app/auth/role.dart';

class User {
  final String id;
  final String email;
  final String username;
  final List<Role> roles;
  final String token;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.roles,
    required this.token,
  });
}
