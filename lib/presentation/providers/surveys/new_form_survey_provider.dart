import 'package:encuestas_app/infrastructure/inputs/inputs.dart';
import 'package:encuestas_app/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

class NewFormSurveyState {
  final bool isValid;
  final bool isPosting;
  final bool isFormPosted;
  final String? id;
  final Title title;
  final Description description;

  NewFormSurveyState(
      {this.isValid = false,
      this.isPosting = false,
      this.isFormPosted = false,
      this.id,
      this.title = const Title.dirty(''),
      this.description = const Description.dirty('')});

  NewFormSurveyState copyWith({
    bool? isValid,
    bool? isPosting,
    bool? isFormPosted,
    String? id,
    Title? title,
    Description? description,
  }) =>
      NewFormSurveyState(
        isValid: isValid ?? this.isValid,
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
      );

  @override
  String toString() {
    return '''

  NewFormSurveyState:
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    title: $title
    description: $description
    ''';
  }
}

class NewFormSurveyNotifier extends StateNotifier<NewFormSurveyState> {
  final Function(String, String) createSurveyCallback;

  NewFormSurveyNotifier({required this.createSurveyCallback})
      : super(NewFormSurveyState());

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

  onFormSubmit() async {
    _touchEveryField();
    if (!state.isValid) return false;

    state = state.copyWith(
      isPosting: true,
    );

    await createSurveyCallback(state.title.value, state.description.value);
    state = state.copyWith(isPosting: false);
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

final newFormSurveyProvider = StateNotifierProvider.autoDispose<NewFormSurveyNotifier, NewFormSurveyState>((ref) {
  final createSurveyCallback = ref.watch(newSurveyProvider.notifier).createSurvey;
  return NewFormSurveyNotifier(createSurveyCallback: createSurveyCallback);
});
