import "package:encuestas_app/infrastructure/mappers/question_mapper.dart";
import "package:encuestas_app/question/question.dart";
import "package:encuestas_app/survey/survey.dart";

class SurveyMapper {
  static Survey fromJson(Map<String, dynamic> json) {
    return Survey(
      id: json["_id"],
      idUser: json["idUser"],
      title: json["title"],
      description: json["description"],
      questions: List<Question>.from(json["questions"].map((x) => QuestionMapper.fromJson(x))),
      v: json["__v"],
    );
  }
}
