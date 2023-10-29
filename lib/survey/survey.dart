import "package:encuestas_app/question/question.dart";

class Survey {
    final String id;
    final String idUser;
    final String title;
    final String description;
    final List<Question> questions;
    final int v;

    Survey({
        required this.id,
        required this.idUser,
        required this.title,
        required this.description,
        required this.questions,
        required this.v,
    });
}

