import 'package:encuestas_app/presentation/providers/providers.dart';
import 'package:encuestas_app/survey/survey.dart';
import 'package:encuestas_app/survey/surveys_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewSurveyState {
  final Survey? survey;
  final bool isLoading;
  final bool isSaving;
  final bool created;
  final String message;
  final bool isPosting;

  NewSurveyState(
      {this.survey,
      this.isLoading = true,
      this.isSaving = false,
      this.created = false,
      this.message = '',
      this.isPosting = false});

  NewSurveyState copywith({
    Survey? survey,
    bool? isLoading,
    bool? isSaving,
    bool? created,
    String? message,
    bool? isPosting,
  }) =>
      NewSurveyState(
        survey: survey ?? this.survey,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
        created: created ?? this.created,
        message: message ?? this.message,
        isPosting: isPosting ?? this.isPosting,
      );
}

class NewSurveyNotifier extends StateNotifier<NewSurveyState> {
  final SurveysData surveysData;

  NewSurveyNotifier({required this.surveysData}) : super(NewSurveyState());

  Future<void> createSurvey(String title, String description) async {
    try {
      final newSurvey = await surveysData.createSurvey(title, description);
      state = state.copywith(
        created: true,
        survey: newSurvey,
      );
    } catch (error) {
      throw Exception();
    }
  }

}

final newSurveyProvider = StateNotifierProvider.autoDispose<NewSurveyNotifier, NewSurveyState>((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';
  final surveysData = SurveysData(accessToken: accessToken);
  return NewSurveyNotifier(surveysData: surveysData);
});
