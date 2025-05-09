import 'package:expense_tracker_app/core/common/widgets/bottom_navigation_bar/app_bottom_navigation_bar.dart';
import 'package:expense_tracker_app/features/Account/presentation/pages/account_page.dart';
import 'package:expense_tracker_app/features/auth/presentation/pages/email_sent_page.dart';
import 'package:expense_tracker_app/features/auth/presentation/pages/login_page.dart';
import 'package:expense_tracker_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:expense_tracker_app/features/budget/presentation/pages/budget_page.dart';
import 'package:expense_tracker_app/features/home/presentation/pages/home_page.dart';
import 'package:expense_tracker_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:expense_tracker_app/features/splash/presentation/pages/splash_page.dart';
import 'package:expense_tracker_app/features/transaction/presentation/pages/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'route_paths.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, statefulNavigationShell) {
          return AppBottomNavigationBar(
            statefulNavigationShell: statefulNavigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.home,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: HomePage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.transaction,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: TransactionPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.budget,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: BudgetPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.account,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: AccountPage(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
