import 'package:encuestas_app/presentation/providers/providers.dart';
import "package:encuestas_app/presentation/widgets/widgets.dart";
import 'package:encuestas_app/question/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultsScreen extends ConsumerWidget {
  final String surveyId;
  const ResultsScreen({super.key, required this.surveyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultState = ref.watch(surveyProvider(surveyId));
    ref.watch(surveyProvider(surveyId).notifier).loadSurvey();
    return Scaffold(
      backgroundColor: const Color(0xFFf0f4fc),
      appBar: AppBar(
        backgroundColor: const Color(0xFFf0f4fc),
      ),
      body: resultState.isLoading
          ? const FullScreenLoader()
          : ResultsView(questions: resultState.survey!.questions),
    );
  }
}

class ResultsView extends StatelessWidget {
  final List<Question>? questions;

  const ResultsView({super.key, this.questions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Resultados",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: Color(0xFF303030),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: questions!.isEmpty
                ? const Center(
                    child: Text(
                    'No hay preguntas',
                    style: TextStyle(color: Color(0xFF6B6B6B)),
                  ))
                : ListView.builder(
                    itemCount: questions?.length ?? 0,
                    itemBuilder: (context, index) {
                      final question = questions![index];
                      switch (question.typeQuestion) {
                        case 'open':
                          return OpenQuestionWidget(question: question);
                        case 'singleOption':
                        case 'multipleOption':
                          return SingleOptionQuestionWidget(
                            question: question,
                          );
                        default:
                          return const SizedBox();
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class OpenQuestionWidget extends StatelessWidget {
  final Question? question;
  const OpenQuestionWidget({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    // Aquí puedes personalizar el widget para preguntas "open"
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(question!.question,
            style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF7F8691),
                fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 20,
        ),
        DataTable(
          headingRowColor: MaterialStateProperty.all(const Color(0xFF648fe4)),
          border: TableBorder.all(color: const Color(0xFF648fe4)),
          columns: const [
            DataColumn(
                label: Text(
              'Respuestas',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            )),
            DataColumn(
                label: Text(
              'Cantidad',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            )),
          ],
          rows: question!.answers
              .map((answer) => DataRow(
                    cells: [
                      DataCell(Text(
                        answer.answer,
                        style: const TextStyle(color: Color(0xFF7F8691)),
                      )),
                      DataCell(Text(answer.count.toString(),
                          style: const TextStyle(color: Color(0xFF7F8691)))),
                    ],
                  ))
              .toList(),
        ),
        const SizedBox(
          height: 50,
        )
      ],
    );
  }
}

class SingleOptionQuestionWidget extends StatelessWidget {
  final Question? question;
  const SingleOptionQuestionWidget({super.key, this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(question!.question,
            style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF7F8691),
                fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 20,
        ),
        BarChartResult(answers: question!.answers),
        const SizedBox(
          height: 50,
        )
      ],
    );
  }
}
