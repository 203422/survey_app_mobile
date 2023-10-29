import 'package:encuestas_app/auth/auth_errors.dart';
import 'package:encuestas_app/auth/user.dart';
import 'package:dio/dio.dart';
import 'package:encuestas_app/config/constants/environment.dart';
import 'package:encuestas_app/infrastructure/mappers/user_mapper.dart';

class AuthUser {
  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
  ));

  Future<User> signin(String email, String password) async {
    try {
      final response = await dio.post('/signin', data: {
        'email': email,
        'password': password,
      });

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw CustomError(
            error.response?.data['error'] ?? 'Credenciales incorrectas');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw CustomError('Revisar conexión a internet');
      }
      if (error.response?.statusCode == 404) {
        throw CustomError(
            error.response?.data['error'] ?? 'El usuario no existe');
      }
      throw Exception();
    } catch (error) {
      throw Exception();
    }
  }

  Future<String> signup(String username, String email, String password) async {
    try {
      final response = await dio.post('/signup', data: {
        'username': username,
        'email': email,
        'password': password,
      });

      final userCreated = response.data['message'];
      return userCreated;
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw CustomError(error.response?.data['error'] ?? 'Usuario existente');
      }

      if (error.type == DioExceptionType.connectionError) {
        throw CustomError('Revisar conexión a internet');
      }

      throw Exception();
    } catch (error) {
      throw Exception();
    }
  }

  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get('/user',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw CustomError(error.response?.data['message'] ?? 'No valido');
      }

      throw Exception();
    } catch (error) {
      throw Exception();
    }
  }

  Future getAllUsers(String token) async {
    try {
      final response = await dio.get('/users',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      final users = response.data;
      return users;
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return CustomError(
            error.response?.data['message'] ?? 'Usuarios no encontrados');
      }
    } catch (error) {
      throw Exception();
    }
  }
}
