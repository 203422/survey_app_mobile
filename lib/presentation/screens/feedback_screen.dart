import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FeedBackScreen extends StatelessWidget {
  const FeedBackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf0f4fc),
      appBar: AppBar(
        backgroundColor: const Color(0xFFf0f4fc),
      ),
      body: const FeedBackView(),
    );
  }
}

class FeedBackView extends StatelessWidget {
  const FeedBackView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Respuestas enviadas',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: Color(0xFF303030)),
        ),
        const SizedBox(height: 10,),
        const Text('Gracias por tomarte el tiempo de responder la encuesta.', textAlign: TextAlign.center,),
        Lottie.network(
            'https://lottie.host/09793208-e2de-4fd8-8a65-389c790a0664/orGkn5MQIB.json'),
      ],
    );
  }
}
