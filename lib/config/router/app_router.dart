import 'package:encuestas_app/config/router/app_router_notifier.dart';
import 'package:encuestas_app/presentation/providers/auth/auth_provider.dart';
import 'package:encuestas_app/presentation/screens/screens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      GoRoute(
        path: '/splash',
        name: CheckAuthScreen.name,
        builder: (context, state) => const CheckAuthScreen(),
      ),
      GoRoute(
        path: '/home',
        name: HomeScreen.name,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: SignUpScreen.name,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/signin',
        name: SignInScreen.name,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: Dashboard.name,
        builder: (context, state) => const Dashboard(),
      ),
      GoRoute(
        path: '/usuarios',
        name: UsersScreen.name,
        builder: (context, state) => const UsersScreen(),
      ),
      GoRoute(
        path: '/create-survey',
        name: CreateSurveyScreen.name,
        builder: (context, state) => const CreateSurveyScreen(),
      ),
      GoRoute(
        path: '/survey/:id',
        builder: (context, state) => SurveyScreen(
          surveyId: state.pathParameters['id'] ?? 'No ID',
        ),
      ),
      GoRoute(
        path: '/form/:id',
        builder: (context, state) => SurveyShared(
          surveyId: state.pathParameters['id'] ?? 'No ID',
        ),
      ),
      GoRoute(
        path: '/results/:id',
        builder: (context, state) => ResultsScreen(
          surveyId: state.pathParameters['id'] ?? 'No ID',
        ),
      ),
      GoRoute(
        path: '/succesfull',
        builder: (context, state) => const FeedBackScreen(),
      ),
    ],
    redirect: (context, state) {
      final isGoinTo = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;

      if (isGoinTo == '/splash' && authStatus == AuthStatus.checking) return null;

      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoinTo == '/signin' || isGoinTo == '/signup') return null;

        return '/home';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoinTo == '/signin' ||
            isGoinTo == '/signup' ||
            isGoinTo == '/splash' ||
            isGoinTo == '/home') return '/dashboard';
      }

      return null;
    },
  );
});
