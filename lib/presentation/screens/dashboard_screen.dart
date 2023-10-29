import 'package:encuestas_app/presentation/providers/providers.dart';
import "package:encuestas_app/presentation/screens/screens.dart";
import "package:encuestas_app/presentation/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

class Dashboard extends StatelessWidget {
  static const String name = 'dashboard';

  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFf0f4fc),
      appBar: AppBar(
        backgroundColor: const Color(0xFFf0f4fc),
      ),
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      body: const DashboardSurveysView(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0E2045),
        onPressed: () {
          context.pushNamed(CreateSurveyScreen.name);
        },
        label: const Text(
          'Nueva encuesta',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class DashboardSurveysView extends ConsumerWidget {
  const DashboardSurveysView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surveysState = ref.watch(surveysProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                'Mis ',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF303030)),
              ),
              Text(
                'Encuestas',
                style: TextStyle(fontSize: 28, color: Color(0xFF6B6B6B)),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: surveysState.surveys.isEmpty
                ? const Center(child: Text('No hay encuestas creadas', style: TextStyle(color: Color(0xFF6B6B6B)),))
                : ListView.builder(
                    itemCount: surveysState.surveys.length,
                    itemBuilder: (context, index) {
                      final survey = surveysState.surveys[index];
                      return GestureDetector(
                        onTap: () => context.push('/survey/${survey.id}'),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(10),
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
                            leading: const Icon(Icons.task,
                                color: Color(0xFFFFFFFF)),
                            title: Text(
                              survey.title,
                              style: const TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              'Preguntas: ${survey.questions.length.toString()}',
                              style: const TextStyle(color: Color(0xFFFFFFFF)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
