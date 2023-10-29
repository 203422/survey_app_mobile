import 'package:encuestas_app/presentation/providers/providers.dart';
import 'package:encuestas_app/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:go_router/go_router.dart';

class CreateSurveyScreen extends StatelessWidget {
  static const String name = 'create-survey';

  const CreateSurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF648fe4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF648fe4),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const CreateSurveyView(),
    );
  }
}

class CreateSurveyView extends StatelessWidget {
  const CreateSurveyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Nueva',
                style: TextStyle(
                color: Colors.white, fontSize: 42, fontWeight: FontWeight.w500),
              ),
              Text(
                'encuesta',
                style: TextStyle(
                color: Colors.white, fontSize: 42, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(70)),
            child: Container(
              color: Colors.white,
              width: double.infinity,
              child: const Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      children: [CreateSurveyForm()],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class CreateSurveyForm extends ConsumerWidget {
  const CreateSurveyForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newFormSurvey = ref.watch(newFormSurveyProvider);

    ref.listen(newSurveyProvider, (previous, next) {
      if (next.created == true) {
        final surveyId = next.survey?.id;
        context.pushReplacement('/survey/$surveyId');
      }
    });

    return Form(
        child: Column(
      children: [
        CustomSurveyField(
          isTopField: true,
          isBottomField: true,
          label: 'Titulo de la encuesta',
          onChanged: ref.read(newFormSurveyProvider.notifier).onTitleChanged,
          errorMessage: newFormSurvey.isFormPosted
              ? newFormSurvey.title.errorMessage
              : null,
        ),
        const SizedBox(
          height: 10,
        ),
        CustomSurveyField(
          label: 'Descripción',
          isTopField: true,
          isBottomField: true,
          onChanged:
              ref.read(newFormSurveyProvider.notifier).onDescriptionChanged,
          errorMessage: newFormSurvey.isFormPosted
              ? newFormSurvey.description.errorMessage
              : null,
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              newFormSurvey.isPosting
                  ? null
                  : ref.read(newFormSurveyProvider.notifier).onFormSubmit();
              ref.read(surveysProvider.notifier).loadSurveys();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF648fe4),
              foregroundColor: Colors.white,
            ),
            child: const Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                'Crear encuesta',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
