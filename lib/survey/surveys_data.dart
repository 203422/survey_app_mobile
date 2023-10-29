import 'package:dio/dio.dart';
import 'package:encuestas_app/auth/auth_errors.dart';
import 'package:encuestas_app/config/constants/environment.dart';
import 'package:encuestas_app/infrastructure/errors/survey_error.dart';
import 'package:encuestas_app/infrastructure/mappers/mappers.dart';
import 'package:encuestas_app/survey/survey.dart';

class SurveysData {
  late final Dio dio;
  final String accessToken;
  final String? id;

  SurveysData({required this.accessToken, this.id})
      : dio = Dio(BaseOptions(
            baseUrl: Environment.apiUrl,
            headers: {'Authorization': 'Bearer $accessToken'}));

  Future<List> getSurveys() async {
    try {
      final response = await dio.get('/surveys');
      final List<Survey> surveys = [];
      for (final survey in response.data) {
        surveys.add(SurveyMapper.fromJson(survey));
      }

      return surveys;
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        throw CustomError(
            error.response?.data['message'] ?? 'No se encontraron encuestas');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (error) {
      throw Exception();
    }
  }

  Future getSurveyById() async {
    try {
      final response = await dio.get('/surveys/$id');
      final survey = SurveyMapper.fromJson(response.data);
      return survey;
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) throw SurveyNotFound();
      throw Exception();
    } catch (error) {
      throw Exception();
    }
  }

  Future deleteSurvey(String surveyId) async {
    try {
      final response = await dio.delete('/surveys/$surveyId');
      final List<Survey> surveys = [];
      for (final survey in response.data) {
        surveys.add(SurveyMapper.fromJson(survey));
      }
      return surveys;
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        throw CustomError(
            error.response?.data['message'] ?? 'Error al eliminar la encuesta');
      }

      if (error.response?.statusCode == 500) {
        throw CustomError(
            error.response?.data['message'] ?? 'Error al eliminar la encuesta');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  Future createSurvey(String title, String description) async {
    try {
      final response = await dio.post('/surveys', data: {
        'title': title,
        'description': description,
      });

      final surveyCreated = SurveyMapper.fromJson(response.data);
      return surveyCreated;
    } on DioException catch (error) {
      if (error.response?.statusCode == 500) {
        throw CustomError(
            error.response?.data['message'] ?? 'Error al crear la encuesta');
      }
      return Exception();
    } catch (error) {
      return Exception();
    }
  }

  Future updateSurvey(String title, String description) async {
    try {
      final response = await dio.put('/surveys/$id', data: {
        'title': title,
        'description': description,
      });
      final surveyUpdated = response.data;
      return surveyUpdated;
    } on DioException catch (error) {
      if (error.response?.statusCode == 500) {
        throw CustomError(error.response?.data['message'] ??
            'Error al actualizar la encuesta');
      }
      return Exception();
    } catch (error) {
      return Exception();
    }
  }

  Future createOrUpdateQuestion(Map<String, dynamic> questionLike) async {
    try {
      final String questionId = questionLike['id'];
      final String surveyId = questionLike['surveyId'];
      final String method = (questionId == 'new') ? 'POST' : 'PUT';
      final String url = (questionId == 'new')
          ? '/surveys/questions/$surveyId'
          : '/questions/$questionId';

      questionLike.remove('id');
      if (method == 'PUT') {
        questionLike.remove('typeQuestion');
      }

      final response = await dio.request(url,
          data: questionLike, options: Options(method: method));
      final questions = SurveyMapper.fromJson(response.data).questions;
      return questions;
    } on DioException catch (error) {
      if (error.response?.statusCode == 500) {
        throw CustomError(error.response?.data['message'] ??
            'Error al actualizar la pregunta');
      }
      return Exception();
    } catch (error) {
      return Exception();
    }
  }

  Future deleteQuestion(String idSurvey, String questionId) async {
    try {
      final response = await dio.delete('/questions/$questionId', data: {
        'idSurvey': idSurvey,
      });

      final questions = SurveyMapper.fromJson(response.data).questions;
      return questions;
      
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        throw CustomError(
            error.response?.data['message'] ?? 'Error al eliminar la pregunta');
      }

      if (error.response?.statusCode == 500) {
        throw CustomError(
            error.response?.data['message'] ?? 'Error al eliminar la pregunta');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  Future saveAnswers(Map<String, dynamic> responses) async {
    try {
      final response = await dio.post('/form', data: {
        'responses': responses,
      });
      final answersSaved = response.data;
      return answersSaved;
    } catch (error) {
      throw Exception();
    }
  }
}
