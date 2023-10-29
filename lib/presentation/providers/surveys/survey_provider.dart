import 'package:encuestas_app/presentation/providers/providers.dart';
import 'package:encuestas_app/question/question.dart';
import 'package:encuestas_app/survey/survey.dart';
import 'package:encuestas_app/survey/surveys_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurveyState {
  final String id;
  final Survey? survey;
  final bool isLoading;
  final bool isSaving;
  final bool created;
  final String message;
  final bool isPosting;
  final bool isDeleted;
  final List<Question> questions;

  SurveyState(
      {required this.id,
      this.survey,
      this.isLoading = true,
      this.isSaving = false,
      this.created = false,
      this.message = '',
      this.isPosting = false,
      this.isDeleted = false,
      this.questions = const []});

  SurveyState copywith({
    String? id,
    Survey? survey,
    bool? isLoading,
    bool? isSaving,
    bool? created,
    String? message,
    bool? isPosting,
    bool? isDeleted,
    List<Question>? questions,
  }) =>
      SurveyState(
        id: id ?? this.id,
        survey: survey ?? this.survey,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
        created: created ?? this.created,
        message: message ?? this.message,
        isPosting: isPosting ?? this.isPosting,
        isDeleted: isDeleted ?? this.isDeleted,
        questions: questions ?? this.questions,
      );
}

class SurveyNotifier extends StateNotifier<SurveyState> {
  final SurveysData surveysData;

  SurveyNotifier({required String surveyId, required this.surveysData})
      : super(SurveyState(id: surveyId)) {
    loadSurvey();
  }

  Future<void> loadSurvey() async {
    try {
      final survey = await surveysData.getSurveyById();
      state = state.copywith(
        isLoading: false,
        survey: survey,
        questions: survey.questions
      );
    } catch (error) {
      throw Exception();
    }
  }
}

final surveyProvider = StateNotifierProvider.autoDispose
    .family<SurveyNotifier, SurveyState, String>((ref, surveyId) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';
  final surveysData = SurveysData(accessToken: accessToken, id: surveyId);
  return SurveyNotifier(surveyId: surveyId, surveysData: surveysData);
});
