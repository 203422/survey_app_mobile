import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class CheckAuthScreen extends ConsumerWidget {

  static const String name = 'check_auth_screen';

  const CheckAuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(strokeWidth: 2,),
      ),
    );
  }
}