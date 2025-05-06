import 'package:expense_tracker_app/features/auth/presentation/pages/email_sent_page.dart';
import 'package:expense_tracker_app/features/auth/presentation/pages/login_page.dart';
import 'package:expense_tracker_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:expense_tracker_app/features/home/presentation/pages/home_page.dart';
import 'package:expense_tracker_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:expense_tracker_app/features/splash/presentation/pages/splash_page.dart';
import 'package:go_router/go_router.dart';

part 'route_paths.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RoutePaths.root,
    routes: [
      GoRoute(
        path: RoutePaths.root,
        builder: (context, state) => SplashPage(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (context, state) => OnboardingPage(),
      ),
      GoRoute(
        path: RoutePaths.signUp,
        builder: (context, state) => SignUpPage(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: RoutePaths.emailSent,
        builder: (context, state) => EmailSentPage(),
      ),
      GoRoute(
        path: RoutePaths.home,
        builder: (context, state) => HomePage(),
      ),
    ],
  );
}
