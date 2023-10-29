import 'package:encuestas_app/auth/role.dart';
import 'package:encuestas_app/auth/user.dart';
import 'package:encuestas_app/infrastructure/mappers/rol_mapper.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['email'],
        username: json['username'],
        roles: List<Role>.from(json["roles"].map((x) => RoleMapper.fromJson(x))),
        token: json['token'],
      );
}
