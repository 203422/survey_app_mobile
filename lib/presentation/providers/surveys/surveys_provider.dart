import 'package:encuestas_app/presentation/providers/providers.dart';
import 'package:encuestas_app/survey/survey.dart';
import 'package:encuestas_app/survey/surveys_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurveysState {
  final bool isLoading;
  final List<Survey> surveys;
  final String message;
  final bool isDeleted;

  SurveysState({
    this.isLoading = false,
    this.surveys = const [],
    this.message = '',
    this.isDeleted = false,
  });

  SurveysState copyWith(
          {bool? isLoading,
          List<Survey>? surveys,
          String? message,
          bool? isDeleted}) =>
      SurveysState(
        isLoading: isLoading ?? this.isLoading,
        surveys: surveys ?? this.surveys,
        message: message ?? this.message,
        isDeleted: isDeleted ?? this.isDeleted,
      );
}

class SurveysNotifier extends StateNotifier<SurveysState> {
  SurveysNotifier(this.surveysData) : super(SurveysState()) {
    loadSurveys();
  }

  final SurveysData surveysData;

  Future loadSurveys() async {
    try {
      final surveys = await surveysData.getSurveys();

      if (surveys.isEmpty) {
        state = state.copyWith(
          isLoading: false,
        );

        return;
      }
      state = state.copyWith(isLoading: true, surveys: [...surveys]);
    } catch (error) {
      throw Exception();
    }
  }

  void deleteSurvey(String surveyId) async {
    try {
      final surveys = await surveysData.deleteSurvey(surveyId);
      state = state.copyWith(
        isLoading: true,
        isDeleted: true,
        message: 'Encuesta eliminada',
        surveys: [...surveys],
      );
    } catch (error) {
      throw Exception();
    }
    state = state.copyWith(isDeleted: false);
  }
}

final surveysProvider =
    StateNotifierProvider<SurveysNotifier, SurveysState>((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';
  return SurveysNotifier(SurveysData(accessToken: accessToken));
});
