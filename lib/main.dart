import 'package:encuestas_app/config/constants/environment.dart';
import 'package:encuestas_app/config/router/app_router.dart';
import 'package:encuestas_app/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
void main() async {
  
  await Environment.initEnvironment();

  runApp( 
    const ProviderScope(child: MyApp()
    )
  );
}

class MyApp extends ConsumerWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final appRouter = ref.watch(appRouterProvider);

    return  MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: 0).getTheme(),
    );
  }
}
