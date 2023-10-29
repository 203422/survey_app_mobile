import "package:encuestas_app/answer/answer.dart";

class Question {
  final String? id;
  final String? idUser;
  final String? idSurvey;
  final String typeQuestion;
  final String question;
  final List<Answer> answers;
  final int? v;

  Question({
    this.id,
    this.idUser,
    this.idSurvey,
    required this.typeQuestion,
    required this.question,
    required this.answers,
    this.v,
  });
}
