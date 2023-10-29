import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {

  static initEnvironment() async {
      await dotenv.load(fileName: '.env');
  }

  static String apiUrl = dotenv.env['API_URL'] ?? 'No está configura el API_URL';
  static String urlSurvey = dotenv.env['URL_SURVEY'] ?? 'No está configura el URL_SURVEY ';

}