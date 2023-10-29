import "package:encuestas_app/answer/answer.dart";
import "package:encuestas_app/infrastructure/mappers/answer_mapper.dart";
import "package:encuestas_app/question/question.dart";

class QuestionMapper {
  static Question fromJson(Map<String, dynamic> json) {
    return Question(
      id: json["_id"],
      idUser: json["idUser"],
      idSurvey: json["idSurvey"],
      typeQuestion: json["typeQuestion"],
      question: json["question"],
      answers: List<Answer>.from(json["answers"].map((x) => AnswerMapper.fromJson(x))),
      v: json["__v"],
    );
  }
}
