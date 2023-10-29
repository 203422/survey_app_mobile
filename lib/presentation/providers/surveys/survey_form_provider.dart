import 'package:encuestas_app/infrastructure/inputs/inputs.dart';
import 'package:encuestas_app/presentation/providers/providers.dart';
import 'package:encuestas_app/question/question.dart';
import 'package:encuestas_app/survey/survey.dart';
import 'package:encuestas_app/survey/surveys_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

class SurveyFormState {
  final bool isValid;
  final bool isPosting;
  final bool isFormPosted;
  final String? id;
  final Title title;
  final Description description;
  final List<Question> questions;

  SurveyFormState({
    this.isFormPosted = false,
    this.isPosting = false,
    this.isValid = false,
    this.id,
    this.title = const Title.dirty(''),
    this.description = const Description.dirty(''),
    this.questions = const [],
  });

  SurveyFormState copyWith({
    bool? isValid,
    bool? isPosting,
    bool? isFormPosted,
    String? id,
    Title? title,
    Description? description,
    List<Question>? questions,
  }) =>
      SurveyFormState(
        isValid: isValid ?? this.isValid,
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        questions: questions ?? this.questions,
      );
}

class SurveyFormNotifier extends StateNotifier<SurveyFormState> {
  final Survey survey;
  final Function(String, String)? updateCallback;
  final QuestionNotifier? questionData;
  final Function? createOrUpdateCallback;
  final Function(String, String)? deleteCallback;

  SurveyFormNotifier(
      {required this.survey,
      this.updateCallback,
      this.questionData,
      this.createOrUpdateCallback,
      this.deleteCallback})
      : super(SurveyFormState(
          id: survey.id,
          title: Title.dirty(survey.title),
          description: Description.dirty(survey.description),
          questions: survey.questions,
        ));

  onTitleChanged(String value) {
    final newTitle = Title.dirty(value);
    state = state.copyWith(
        title: newTitle,
        isValid: Formz.validate([newTitle, state.description]));
  }

  onDescriptionChanged(String value) {
    final newDescription = Description.dirty(value);
    state = state.copyWith(
        description: newDescription,
        isValid: Formz.validate([newDescription, state.title]));
  }

  createNewQuestion(String typeOfQuestion) {
    final newQuestion = Question(
      id: 'new',
      typeQuestion: typeOfQuestion,
      question: '',
      answers: [],
    );
    return newQuestion;
  }

  Future createOrUpdateQuestions(questionLike) async {
    try {
      final questions = await createOrUpdateCallback!(questionLike);
      state = state.copyWith(questions: questions);
    } catch (error) {
      state = state.copyWith(isValid: false);
    }
  }

  Future onFormSubmit() async {
    _touchEveryField();
    if (!state.isValid) return false;
    if (updateCallback == null) return false;

    await updateCallback!(state.title.value, state.description.value);
    return true;
  }

  Future deleteQuestion(String idSurvey, String questionId) async {
    try {
      final questionsUpdated = await deleteCallback!(idSurvey, questionId);
      state = state.copyWith(questions: questionsUpdated);
    } catch (error) {
      throw Exception();
    }
  }

  _touchEveryField() {
    final title = Title.dirty(state.title.value);
    final description = Description.dirty(state.description.value);

    state = state.copyWith(
        isFormPosted: true,
        title: title,
        description: description,
        isValid: Formz.validate([title, description]));
  }
}

final surveyFormProvider = StateNotifierProvider.autoDispose
    .family<SurveyFormNotifier, SurveyFormState, Survey>((ref, survey) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';
  final updateCallback =
      SurveysData(accessToken: accessToken, id: survey.id).updateSurvey;
  final questionPro = ref.read(questionProvider.notifier);
  final createOrUpdate =
      SurveysData(accessToken: accessToken).createOrUpdateQuestion;
  final deleteCallback = SurveysData(accessToken: accessToken).deleteQuestion;

  return SurveyFormNotifier(
    survey: survey,
    updateCallback: updateCallback,
    questionData: questionPro,
    createOrUpdateCallback: createOrUpdate,
    deleteCallback: deleteCallback,
  );
});
