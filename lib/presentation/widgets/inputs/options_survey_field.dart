import 'package:encuestas_app/presentation/providers/surveys/survey_form_provider.dart';
import 'package:encuestas_app/presentation/screens/survey_screen.dart';
import 'package:encuestas_app/survey/survey.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OptionsSurveyField extends ConsumerWidget {
  final Survey survey;

  const OptionsSurveyField({super.key, required this.survey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      backgroundColor: const Color(0xFFFFFFFF),
      content: const Text(
        'Selecciona el tipo de pregunta',
        textAlign: TextAlign.center,
      ),
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsOverflowButtonSpacing: 10,
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            final newQuestion = ref.read(surveyFormProvider(survey).notifier).createNewQuestion('open');
            context.pop();
            showDialog(context: context, builder: (context) => QuestionDetails(question: newQuestion, survey: survey),);            
          },
          label: const Text('Respuesta abierta'),
          icon: const Icon(Icons.text_fields),
        ),
        ElevatedButton.icon(
          onPressed: () {
            final newQuestion = ref.read(surveyFormProvider(survey).notifier).createNewQuestion('singleOption');
            context.pop();
            showDialog(context: context, builder: (context) => QuestionDetails(question: newQuestion, survey: survey,),);
          },
          label: const Text('Opción unica'),
          icon: const Icon(Icons.radio_button_checked),
        ),
        ElevatedButton.icon(
          onPressed: () {
            final newQuestion = ref.read(surveyFormProvider(survey).notifier).createNewQuestion('multipleOption');
            context.pop();
            showDialog(context: context, builder: (context) => QuestionDetails(question: newQuestion, survey: survey,),);
          },
          label: const Text('Opción multiple'),
          icon: const Icon(Icons.check_box),
        )
      ],
    );
  }
}


