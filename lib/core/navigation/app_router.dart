import 'package:expense_tracker_app/core/common/cubits/type/selected_type_cubit.dart';
import 'package:expense_tracker_app/core/common/widgets/bottom_navigation_bar/app_bottom_navigation_bar.dart';
import 'package:expense_tracker_app/features/Account/presentation/pages/account_page.dart';
import 'package:expense_tracker_app/features/auth/presentation/pages/email_sent_page.dart';
import 'package:expense_tracker_app/features/auth/presentation/pages/login_page.dart';
import 'package:expense_tracker_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:expense_tracker_app/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_tracker_app/features/budget/presentation/pages/add_or_edit_budget_page.dart';
import 'package:expense_tracker_app/features/budget/presentation/pages/budget_page.dart';
import 'package:expense_tracker_app/features/budget/presentation/pages/detail_budget_page.dart';
import 'package:expense_tracker_app/features/budget/presentation/pages/finished_budget_page.dart';
import 'package:expense_tracker_app/features/category/domain/entities/category_entity.dart';
import 'package:expense_tracker_app/features/category/presentation/pages/add_or_edit_category_page.dart';
import 'package:expense_tracker_app/features/category/presentation/pages/category_page.dart';
import 'package:expense_tracker_app/features/home/presentation/pages/home_page.dart';
import 'package:expense_tracker_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:expense_tracker_app/features/report/presentation/pages/report_page.dart';
import 'package:expense_tracker_app/features/setting/presentation/pages/currency_page.dart';
import 'package:expense_tracker_app/features/setting/presentation/pages/language_page.dart';
import 'package:expense_tracker_app/features/setting/presentation/pages/setting_page.dart';
import 'package:expense_tracker_app/features/splash/presentation/pages/splash_page.dart';
import 'package:expense_tracker_app/features/transaction/domain/entities/transaction_entity.dart';
import 'package:expense_tracker_app/features/transaction/presentation/pages/add_or_edit_transaction.dart';
import 'package:expense_tracker_app/features/transaction/presentation/pages/detail_transaction_page.dart';
import 'package:expense_tracker_app/features/transaction/presentation/pages/transaction_page.dart';
import 'package:expense_tracker_app/features/wallet/domain/entities/wallet_entity.dart';
import 'package:expense_tracker_app/features/wallet/presentation/bloc/cubit/selected_wallet_cubit.dart';
import 'package:expense_tracker_app/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:expense_tracker_app/features/wallet/presentation/pages/add_or_edit_wallet.dart';
import 'package:expense_tracker_app/features/wallet/presentation/pages/detail_wallet_page.dart';
import 'package:expense_tracker_app/features/wallet/presentation/pages/wallet_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'route_paths.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.root,
    routes: [
      GoRoute(
        path: RoutePaths.root,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: RoutePaths.signUp,
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RoutePaths.emailSent,
        builder: (context, state) => const EmailSentPage(),
      ),
      GoRoute(
        path: RoutePaths.addOrEditTransaction,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final isExpense = extra?['isExpense'] as bool;
          final isEdit = extra?['isEdit'] as bool?;
          final transaction = extra?['transaction'] as TransactionEntity?;
          return AddOrEditTransaction(
            isExpense: isExpense,
            isEdit: isEdit ?? false,
            transactionEntity: transaction,
          );
        },
      ),
      GoRoute(
        path: RoutePaths.detailTransaction,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final transaction = extra?['transaction'] as TransactionEntity;
          return DetailTransactionPage(
            transactionEntity: transaction,
          );
        },
      ),
      GoRoute(
        path: RoutePaths.finishedBudget,
        builder: (context, state) {
          return const FinishedBudgetPage();
        },
      ),
      GoRoute(
        path: RoutePaths.detailBudget,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final budget = extra?['budget'] as BudgetEntity;
          final isFinished = extra?['isFinished'] as bool;
          return DetailBudgetPage(
            budgetEntity: budget,
            isFinished: isFinished,
          );
        },
      ),
      GoRoute(
        path: RoutePaths.addOrEditBudget,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final isEdit = extra?['isEdit'] as bool;
          final budget = extra?['budget'] as BudgetEntity?;
          return AddOrEditBudgetPage(
            isEdit: isEdit,
            budget: budget,
          );
        },
      ),
      GoRoute(
        path: RoutePaths.wallet,
        builder: (context, state) => const WalletPage(),
        routes: [
          GoRoute(
            path: RoutePaths.detailWallet,
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final wallet = extra?['wallet'] as WalletEntity;
              return DetailWalletPage(
                walletEntity: wallet,
              );
            },
          ),
          GoRoute(
            path: RoutePaths.addOrEditWallet,
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final isEdit = extra?['isEdit'] as bool;
              final wallet = extra?['wallet'] as WalletEntity?;
              return AddOrEditWallet(
                isEdit: isEdit,
                wallet: wallet,
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.category,
        builder: (context, state) => const CategoryPage(),
        routes: [
          GoRoute(
            path: RoutePaths.addOrEditCategory,
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final isEdit = extra?['isEdit'] as bool;
              final category = extra?['category'] as CategoryEntity?;
              return  AddOrEditCategoryPage(
                isEdit: isEdit,
                categoryEntity: category,
              );
            },
          ),
        ]
      ),
      GoRoute(
        path: RoutePaths.setting,
        builder: (context, state) => const SettingPage(),
        routes: [
          GoRoute(
            path: RoutePaths.language,
            builder: (context, state) => const LanguagePage(),
          ),
          GoRoute(
            path: RoutePaths.currency,
            builder: (context, state) => const CurrencyPage(),
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.report,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SelectedWalletCubit()
                ..setWallet(context.read<WalletBloc>().state.wallets.firstWhere(
                      (e) => e.walletId == 'total',
                    )),
            ),
            BlocProvider(
              create: (context) => SelectedTypeCubit(),
            ),
          ],
          child: const ReportPage(),
        ),
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
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomePage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.transaction,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: TransactionPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.budget,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: BudgetPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.account,
                pageBuilder: (context, state) => const NoTransitionPage(
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
