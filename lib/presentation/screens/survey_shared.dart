import 'package:encuestas_app/presentation/providers/providers.dart';
import "package:encuestas_app/presentation/widgets/widgets.dart";
import 'package:encuestas_app/question/question.dart';
import 'package:encuestas_app/survey/survey.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SurveyShared extends ConsumerWidget {
  final String surveyId;
  const SurveyShared({super.key, required this.surveyId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surveyForm = ref.watch(formProvider(surveyId));

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFf0f4fc),
        appBar: AppBar(
          backgroundColor: const Color(0xFFf0f4fc),
        ),
        body: surveyForm.isLoading
            ? const FullScreenLoader()
            : FormView(survey: surveyForm.survey!),
      ),
    );
  }
}

class FormView extends ConsumerWidget {
  final Survey survey;
  const FormView({super.key, required this.survey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surveyForm = ref.watch(formProvider(survey.id));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 600, // Define el ancho máximo
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(surveyForm.survey!.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF303030)),),
              const SizedBox(height: 20,),
              Text(surveyForm.survey!.description),
              const SizedBox(height: 20,),
              Expanded(
                child: ListView.builder(
                  itemCount: survey.questions.length + 1,
                  itemBuilder: (context, index) {
                    if (index < survey.questions.length) {
                      final question = survey.questions[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: questionWidget(question),
                      );
                    } else {
                      return ElevatedButton.icon(
                        onPressed: () {
                          final openOptions = ref.read(openOptionProvider.notifier).onSubmit();
                          final singleOptions = ref.read(singleOptionProvider.notifier).onSubmit();
                          final multipleOptions = ref.read(multipleOptionProvider.notifier).onSubmit();
                          ref.read(formProvider(survey.id).notifier).onFormSubmit(survey.id, openOptions, singleOptions, multipleOptions).then((value) {
                            context.go('/succesfull');
                          });
                        },
                        icon: const Icon(Icons.send),
                        label: const Text('Enviar'),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


  questionWidget(question) {
    if (question!.typeQuestion == 'open') {
      return OpenQuestion(
        question: question,
      );
    } else if (question!.typeQuestion == 'singleOption') {
      return SingleOption(
        question: question,
      );
    } else if (question!.typeQuestion == 'multipleOption') {
      return MultipleOption(
        question: question,
      );
    }
  }


class OpenQuestion extends ConsumerWidget {
  final Question? question;
  const OpenQuestion({super.key, this.question});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openProvider = ref.watch(openOptionProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question!.question),
        const SizedBox(
          height: 10,
        ),
        CustomSurveyField(
          hint: 'Escribe algo...',
          initialValue: openProvider.answers[question!.id!] ?? '',
          isBottomField: true,
          isTopField: true,
          onChanged: (value) {
            ref
                .read(openOptionProvider.notifier)
                .onInputChanged(value, question!.id!);
          },
        )
      ],
    );
  }
}

class SingleOption extends ConsumerWidget {
  final Question? question;
  const SingleOption({super.key, this.question});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final singleProvider = ref.watch(singleOptionProvider);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(question!.question),
      const SizedBox(
        height: 10,
      ),
      Column(
        children: question!.answers.map((answer) {
          return RadioListTile(
            title: Text(answer.answer),
            value: answer.answer,
            groupValue: singleProvider.selectedValues[question!.id!] ?? '',
            onChanged: (value) {
              ref.read(singleOptionProvider.notifier).setSelectedValue(value!, question!.id!);
            },
          );
        }).toList(),
      ),
    ]);
  }
}

class MultipleOption extends ConsumerWidget {
  final Question? question;
  const MultipleOption({super.key, this.question});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final multipleProvider = ref.watch(multipleOptionProvider);
    final questionId = question!.id!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question!.question),
        const SizedBox(
          height: 10,
        ),
        Column(
          children: question!.answers.map((answer) {
            final isSelected = multipleProvider.selectedValues[questionId] != null &&
                multipleProvider.selectedValues[questionId]!.contains(answer.answer);

            return CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(answer.answer),
              value: isSelected,
              onChanged: (value) {
                ref.read(multipleOptionProvider.notifier).toggleOptions(answer.answer, questionId);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

