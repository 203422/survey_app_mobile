import 'package:flutter_riverpod/flutter_riverpod.dart';

class OpenOptionState {
  final Map<String, String> answers;

  OpenOptionState({Map<String, String>? answers}) : answers = answers ?? {};

  OpenOptionState copyWith({
    Map<String, String>? answers,
  }) =>
      (OpenOptionState(
        answers: answers ?? this.answers,
      ));
}

class OpenOptionNotifier extends StateNotifier<OpenOptionState> {
  OpenOptionNotifier() : super(OpenOptionState());


  onInputChanged(String value, String questionId) {
    final updatedAnswers = {...state.answers};
    updatedAnswers[questionId] = value;
    state = state.copyWith(answers: updatedAnswers);
  }

  List<Map<String, String>> transformAnswers() {
    final answers = state.answers;
    return answers.entries
        .map((entry) => {
              'questionId': entry.key,
              'answer': entry.value,
            })
        .toList();
  }

  onSubmit() {
    final dataToSubmit = transformAnswers();
    return dataToSubmit;
  }
}

final openOptionProvider = StateNotifierProvider.autoDispose<OpenOptionNotifier, OpenOptionState>(
        (ref) {
  return OpenOptionNotifier();
});

class SingleOptionState {
  final Map<String, String> selectedValues;


 SingleOptionState({Map<String, String>? selectedValues})
      : selectedValues = selectedValues ?? {};

  SingleOptionState copyWith({
    Map<String, String>? selectedValues,
  }) =>
      SingleOptionState(
        selectedValues: selectedValues ?? this.selectedValues,
      );
}

class SingleOptionNotifier extends StateNotifier<SingleOptionState> {
  SingleOptionNotifier() : super(SingleOptionState());

   setSelectedValue(String value, String questionId) {
    final updatedValues = {...state.selectedValues};
    updatedValues[questionId] = value;
    state = state.copyWith(selectedValues: updatedValues);
  }

  onSubmit() {
    final singleOptionData = state.selectedValues.entries
        .map((entry) => {
              'questionId': entry.key,
              'answer': entry.value,
            })
        .toList();

    
    return singleOptionData;
  
  }
}

final singleOptionProvider = StateNotifierProvider.autoDispose<SingleOptionNotifier, SingleOptionState>(
        (ref) {
  return SingleOptionNotifier();
});

class MultipleOptionState {
  final Map<String, List<String>> selectedValues;

  MultipleOptionState({this.selectedValues = const {}});

  MultipleOptionState copyWith({
    Map<String, List<String>>? selectedValues,
  }) =>
      MultipleOptionState(
        selectedValues: selectedValues ?? this.selectedValues,
      );
}

class MultipleOptionNotifier extends StateNotifier<MultipleOptionState> {
  MultipleOptionNotifier() : super(MultipleOptionState());

  toggleOptions(String answer, String questionId) {
    final updatedValues = Map.of(state.selectedValues);

    if (!updatedValues.containsKey(questionId)) {
      updatedValues[questionId] = [];
    }

    if (updatedValues[questionId]!.contains(answer)) {
      updatedValues[questionId]!.remove(answer);
    } else {
      updatedValues[questionId]!.add(answer);
    }

    state = state.copyWith(selectedValues: updatedValues);

    return state.selectedValues;
  }

  onSubmit() {
    final selectedValues = state.selectedValues;
    final multipleOptionData = selectedValues.entries.map((entry) {
      return {
        'questionId': entry.key,
        'answers': entry.value,
      };
    }).toList();

    return multipleOptionData;
  }
}

final multipleOptionProvider = StateNotifierProvider.autoDispose<
    MultipleOptionNotifier, MultipleOptionState>((ref) {
  return MultipleOptionNotifier();
});



// class AnswersFormState {
//   final bool isValid;
//   final bool isPosting;
//   final bool isFormPosted;

//   AnswersFormState(
//       {this.isValid = false,
//       this.isPosting = false,
//       this.isFormPosted = false});

//   AnswersFormState copyWith({
//     bool? isValid,
//     bool? isPosting,
//     bool? isFormPosted,
//   }) =>
//       AnswersFormState(
//           isValid: isValid ?? this.isValid,
//           isPosting: isPosting ?? this.isPosting,
//           isFormPosted: isFormPosted ?? this.isFormPosted);
// }

// class AnswersFormNotifier extends StateNotifier<AnswersFormState> {
//   final Function? submitCallback;
//   final Map<String, dynamic>? answersData;
//   AnswersFormNotifier({this.submitCallback, this.answersData})
//       : super(AnswersFormState());

//   onFormSubmit() {

//     print(answersData);

//   }

// }

// final answersFormProvider = StateNotifierProvider.autoDispose<AnswersFormNotifier, AnswersFormState>((ref) {

//   final openOption = ref.read(openOptionProvider);
//   final singleOption = ref.read(singleOptionProvider).selectedValue;
//   final multipleOption = ref.read(multipleOptionProvider).selectedValues;

//   final answers = {
//     'open': openOption,
//     'singleOption': singleOption,
//     'multipleOption': multipleOption,

//   };

//   return AnswersFormNotifier(answersData: answers);
// });