import 'package:flutter/material.dart';
import 'package:encuestas_app/answer/answer.dart';
import 'package:encuestas_app/config/constants/environment.dart';
import 'package:encuestas_app/presentation/providers/providers.dart';
import "package:encuestas_app/presentation/screens/screens.dart";
import "package:encuestas_app/presentation/widgets/widgets.dart";
import 'package:encuestas_app/question/question.dart';
import 'package:encuestas_app/survey/survey.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SurveyScreen extends ConsumerWidget {
  final String surveyId;

  const SurveyScreen({super.key, required this.surveyId});

  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearMaterialBanners();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Encuesta actualizada')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surveyState = ref.watch(surveyProvider(surveyId));

    ref.listen<SurveysState>(surveysProvider, (previous, next) {
      if (next.isDeleted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.message)));
        context.goNamed(Dashboard.name);
      }
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFf0f4fc),
        appBar: AppBar(
          backgroundColor: const Color(0xFFf0f4fc),
        ),
        bottomNavigationBar: Container(
          color: const Color(0xFFf0f4fc),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FloatingActionButton(
                backgroundColor: const Color(0xFF0E2045),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return OptionsSurveyField(
                        survey: surveyState.survey!,
                      );
                    },
                  );
                },
                heroTag: 'add',
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              FloatingActionButton(
                backgroundColor: const Color(0xFF0E2045),
                onPressed: () {
                  ref
                      .read(surveyFormProvider(surveyState.survey!).notifier)
                      .onFormSubmit()
                      .then((value) {
                    if (!value) return;
                    showSnackbar(context);
                  });
                  ref.read(surveysProvider.notifier).loadSurveys();
                },
                heroTag: 'save',
                child: const Icon(
                  Icons.save,
                  color: Colors.white,
                ),
              ),
              FloatingActionButton(
                backgroundColor: const Color(0xFF3e4d6a),
                onPressed: () {
                  context.push('/results/$surveyId');
                },
                heroTag: 'results',
                child: const Icon(
                  Icons.bar_chart,
                  color: Colors.white,
                ),
              ),
              FloatingActionButton(
                backgroundColor: const Color(0xFF3e4d6a),
                onPressed: ()  {

                  // final url = Uri.parse('${Environment.urlSurvey}/form/$surveyId');
                  print('/form/$surveyId');

                  
                  // await launchUrl(url);
                  // context.push('/form/$surveyId');
  

                },
                heroTag: 'share',
                child: const Icon(
                  Icons.share,
                  color: Colors.white,
                ),
              ),
              FloatingActionButton(
                backgroundColor: const Color(0xFFFF5C5C),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: const Color(0xFFffffff),
                        actionsAlignment: MainAxisAlignment.center,
                        title:
                            const Text('Eliminar', textAlign: TextAlign.center),
                        content: const Text(
                          '¿Estás seguro de eliminar la encuesta?',
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3e4d6a),
                                foregroundColor: Colors.white),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF5C5C),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              ref
                                  .read(surveysProvider.notifier)
                                  .deleteSurvey(surveyId);
                            },
                            child: const Text('Eliminar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                heroTag: 'delete',
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        body: surveyState.isLoading
            ? const FullScreenLoader()
            : SurveyView(survey: surveyState.survey!),
      ),
    );
  }
}

class SurveyView extends ConsumerWidget {
  final Survey survey;

  const SurveyView({super.key, required this.survey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surveyForm = ref.watch(surveyFormProvider(survey));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Row(
            children: [
              Text(
                'Editar ',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF303030)),
              ),
              Text(
                'Encuesta',
                style: TextStyle(fontSize: 28, color: Color(0xFF6B6B6B)),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          CustomSurveyField(
            isTopField: true,
            label: 'Titulo',
            initialValue: surveyForm.title.value,
            onChanged:
                ref.read(surveyFormProvider(survey).notifier).onTitleChanged,
            errorMessage: surveyForm.title.errorMessage,
          ),
          CustomSurveyField(
            isBottomField: true,
            label: 'Descrición',
            initialValue: surveyForm.description.value,
            onChanged: ref
                .read(surveyFormProvider(survey).notifier)
                .onDescriptionChanged,
            errorMessage: surveyForm.description.errorMessage,
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Preguntas',
              style: TextStyle(color: Colors.black54),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          RenderQuestions(survey: survey),
        ],
      ),
    );
  }
}

class RenderQuestions extends ConsumerWidget {
  final Survey survey;
  const RenderQuestions({super.key, required this.survey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surveyState = ref.watch(surveyFormProvider(survey));
    return Expanded(
      child: ListView.builder(
        itemCount: surveyState.questions.length,
        itemBuilder: (context, index) {
          final question = surveyState.questions[index];
          return GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return QuestionDetails(
                      question: question,
                      survey: survey,
                    );
                  });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  color: const Color(0xFF648fe4),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 5,
                        offset: const Offset(0, 3))
                  ]),
              child: ListTile(
                title: Text(
                  question.question,
                  style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  (question.typeQuestion == 'open')
                      ? 'Respuesta abierta'
                      : 'Opciones: ${question.answers.length.toString()}',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class QuestionDetails extends ConsumerWidget {
  final Question question;
  final Survey survey;

  const QuestionDetails(
      {super.key, required this.question, required this.survey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionForm = ref.watch(questionFormProvider(question));
    ref.watch(questionProvider);
    return AlertDialog(
      actionsOverflowAlignment: OverflowBarAlignment.start,
      backgroundColor: const Color(0xFFffffff),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomSurveyField(
              initialValue: questionForm.questionInput.value,
              label: 'Pregunta',
              isTopField: true,
              isBottomField: true,
              onChanged: ref
                  .read(questionFormProvider(question).notifier)
                  .onQuestionChanged,
              errorMessage: questionForm.questionInput.errorMessage,
            ),
            const SizedBox(height: 10),
            const Text(
              'Respuestas',
              style: TextStyle(color: Color(0xFF6B6B6B)),
            ),
            const SizedBox(height: 10),
            RenderAnswers(
              question: question,
            ),
          ],
        ),
      ),
      scrollable: true,
      actions: [
        Visibility(
          visible: question.typeQuestion != 'open',
          child: ElevatedButton.icon(
            onPressed: () {
              ref
                  .read(questionFormProvider(question).notifier)
                  .addAnswer(context);
            },
            icon: const Icon(Icons.add),
            label: const Text(
              'Agregar respuesta',
            ),
          ),
        ),
        Visibility(
          visible: question.id != 'new',
          child: ElevatedButton.icon(
            onPressed: () {
              _showDeleteConfirmationDialog(context, () {
                ref
                    .read(surveyFormProvider(survey).notifier)
                    .deleteQuestion(survey.id, question.id!);
                ref.read(surveysProvider.notifier).loadSurveys();
                Navigator.of(context).pop();
              });
            },
            icon: const Icon(Icons.delete),
            label: const Text('Eliminar pregunta'),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            ref
                .read(questionFormProvider(question).notifier)
                .onFormSubmit(survey.id);
            final questionLike =
                ref.read(questionProvider.notifier).getQuestionData();
            ref
                .read(surveyFormProvider(survey).notifier)
                .createOrUpdateQuestions(questionLike);
            ref.read(surveysProvider.notifier).loadSurveys();
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.save),
          label: const Text('Guardar cambios'),
        ),
      ],
    );
  }
}

Future<void> _showDeleteConfirmationDialog(
    BuildContext context, Function onDelete) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: const Color(0xFFffffff),
          title: const Text('Eliminar', textAlign: TextAlign.center),
          content: const Text('¿Estás seguro de eliminar esta pregunta?',
              textAlign: TextAlign.center),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3e4d6a),
                  foregroundColor: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5C5C),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  onDelete();
                  Navigator.of(context).pop();
                },
                child: const Text('Eliminar')),
          ]);
    },
  );
}

class RenderAnswers extends ConsumerWidget {
  final Question question;
  const RenderAnswers({super.key, required this.question});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionForm = ref.watch(questionFormProvider(question));

    if (question.typeQuestion == "open") {
      return Container(); 
    }

    double height = questionForm.answers.length * 65.0;
    double maxHeight = 200;
    height = height.clamp(0, maxHeight);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: questionForm.answers.length,
              itemBuilder: (context, index) {
                final Answer answer = questionForm.answers[index];
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: CustomSurveyField(
                          hint: answer.answer,
                          isTopField: true,
                          isBottomField: true,
                          onChanged: (value) {
                            ref
                                .read(questionFormProvider(question).notifier)
                                .onAnswerChanged(value, index);
                          },
                          focusNode: ref
                              .read(questionFormProvider(question))
                              .answerFocusNodes[index],
                        )),
                        IconButton(
                            onPressed: () {
                              ref
                                  .read(questionFormProvider(question).notifier)
                                  .deleteAnswer(index);
                            },
                            icon: const Icon(Icons.delete))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }),
        ),
      ],
    );
  }
}
