import "package:encuestas_app/answer/answer.dart";

class AnswerMapper {
  static Answer fromJson(Map<String, dynamic> json) {
    return Answer(
      answer: json["answer"],
      count: json["count"],
      id: json["_id"],
    );
  }
}
