import 'package:encuestas_app/question/question.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultsState {
  final String id;
  final Question? question;
  final bool isLoading;

  ResultsState({required this.id, this.question, this.isLoading = true});

  ResultsState copywith({
    String? id,
    Question? question,
    bool? isLoading,
  }) =>
      ResultsState(
          id: id ?? this.id,
          question: question ?? this.question,
          isLoading: isLoading ?? this.isLoading);
}

class ResultsNotifier extends StateNotifier<ResultsState> {
  ResultsNotifier({required String questionId})
      : super(ResultsState(id: questionId));
}

final resultsProvider = StateNotifierProvider.autoDispose
    .family<ResultsNotifier, ResultsState, String>((ref, questionId) {
  return ResultsNotifier(questionId: questionId);
});
