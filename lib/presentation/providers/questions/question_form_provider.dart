import 'package:encuestas_app/answer/answer.dart';
import 'package:encuestas_app/infrastructure/inputs/inputs.dart';
import 'package:encuestas_app/presentation/providers/providers.dart';
import 'package:encuestas_app/question/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:flutter/scheduler.dart';

class QuestionFormState {
  final bool isValid;
  final bool isPosting;
  final bool isFormPosted;
  final QuestionInput questionInput;
  final List<Answer> answers;
  final List<FocusNode> answerFocusNodes;

  QuestionFormState({
    this.isValid = false,
    this.isPosting = false,
    this.isFormPosted = false,
    this.questionInput = const QuestionInput.pure(),
    this.answers = const [],
    this.answerFocusNodes = const [],
  });

  QuestionFormState copyWith({
    bool? isValid,
    bool? isPosting,
    bool? isFormPosted,
    QuestionInput? questionInput,
    List<Answer>? answers,
    List<FocusNode>? answerFocusNodes,
  }) =>
      QuestionFormState(
        isValid: isValid ?? this.isValid,
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        questionInput: questionInput ?? this.questionInput,
        answers: answers ?? this.answers,
        answerFocusNodes: answerFocusNodes ?? this.answerFocusNodes,
      );
}

class QuestionFormNotifier extends StateNotifier<QuestionFormState> {
  final Question? question;
  final QuestionNotifier? questionData;

  QuestionFormNotifier({
    this.question,
    this.questionData,
  }) : super(QuestionFormState(
          questionInput: QuestionInput.dirty(question!.question),
          answers: question.answers,
        )) {
    for (int i = 0; i < question!.answers.length; i++) {
      final newFocusNodes = FocusNode();
      final updateFocusNodes = List<FocusNode>.from(state.answerFocusNodes)
        ..add(newFocusNodes);
      state = state.copyWith(answerFocusNodes: updateFocusNodes);
    }
  }

  onQuestionChanged(String value) {
    final newQuestion = QuestionInput.dirty(value);
    state = state.copyWith(
        questionInput: newQuestion, isValid: Formz.validate([newQuestion]));
  }

  onAnswerChanged(String value, int index) {
    final updatedAnswers = List<Answer>.from(state.answers);
    final newAnswer = Answer(answer: value);
    updatedAnswers[index] = newAnswer;
    state = state.copyWith(answers: updatedAnswers);
  }

  addAnswer(context) {
    final newAnswer = Answer(answer: '');
    final updatedAnswers = List<Answer>.from(state.answers)..add(newAnswer);
    final newFocus = FocusNode();
    final answerFocusNodes = List<FocusNode>.from(state.answerFocusNodes)
      ..add(newFocus);
    state = state.copyWith(
        answers: updatedAnswers, answerFocusNodes: answerFocusNodes);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(newFocus);
    });
  }

  void deleteAnswer(int index) {
    final answerFocusNodes = List<FocusNode>.from(state.answerFocusNodes);
    final updatedAnswers = List<Answer>.from(state.answers);
    answerFocusNodes.removeAt(index);
    updatedAnswers.removeAt(index);
    state = state.copyWith(
        answers: updatedAnswers, answerFocusNodes: answerFocusNodes);
  }

  onFormSubmit(String surveyId) {
    touchField();
    if (!state.isValid) return false;

    final questionLike = {
      'id': question?.id,
      'surveyId': surveyId,
      'question': state.questionInput.value,
      'typeQuestion': question?.typeQuestion,
      'answers': state.answers
          .where((answer) => answer.answer.trim() != "")
          .map((answer) => {'answer': answer.answer})
          .toList(),
    };
    questionData!.addQuestionData(questionLike);
  }

  touchField() {
    final question = QuestionInput.dirty(state.questionInput.value);
    state = state.copyWith(
        isFormPosted: true,
        questionInput: question,
        isValid: Formz.validate([question]));
  }
}

final questionFormProvider = StateNotifierProvider.autoDispose
    .family<QuestionFormNotifier, QuestionFormState, Question>((ref, question) {
  final questionPro = ref.read(questionProvider.notifier);

  return QuestionFormNotifier(
    question: question,
    questionData: questionPro,
  );
});
