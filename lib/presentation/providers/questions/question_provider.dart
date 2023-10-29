import 'package:encuestas_app/question/question.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionState {
  final String id;
  final Question? question;
  final bool isLoading;
  final bool created;
  final bool isSaving;
  final String message;
  final bool isPosting;
  final bool isDeleted;
  final Map<String, Object?> questionData;

  QuestionState({
    this.id = '',
    this.question,
    this.isLoading = true,
    this.isSaving = false,
    this.created = false,
    this.message = '',
    this.isPosting = false,
    this.isDeleted = false,
    this.questionData = const {},
  });

  QuestionState copyWith({
    String? id,
    Question? question,
    bool? isLoading,
    bool? isSaving,
    bool? created,
    String? message,
    bool? isPosting,
    bool? isDeleted,
    Map<String, Object?>? questionData,
  }) =>
      QuestionState(
        id: id ?? this.id,
        question: question ?? this.question,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
        created: created ?? this.created,
        message: message ?? this.message,
        isPosting: isPosting ?? this.isPosting,
        isDeleted: isDeleted ?? this.isDeleted,
        questionData: questionData ?? this.questionData,
      );
}

class QuestionNotifier extends StateNotifier<QuestionState> {
  QuestionNotifier() : super(QuestionState(id: ''));

  addQuestionData(questionData) {
    state = state.copyWith(questionData: questionData);
  }

  getQuestionData() {
    return state.questionData;
  }
 

}

final questionProvider =
    StateNotifierProvider.autoDispose<QuestionNotifier, QuestionState>((ref) {
  return QuestionNotifier();
});
