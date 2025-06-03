import 'dart:async';

import 'package:expense_tracker_app/core/common/extensions/get_localized_name.dart';
import 'package:expense_tracker_app/core/common/widgets/snack_bar/app_snack_bar.dart';
import 'package:expense_tracker_app/core/navigation/app_router.dart';
import 'package:expense_tracker_app/core/services/notification_service.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker_app/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:expense_tracker_app/features/category/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker_app/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:expense_tracker_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthLoggedIn());
    serviceLocator<NotificationService>().scheduleDailyReminder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.violet100,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthInitial) {
            context.go(RoutePaths.onboarding);
          }

          if (state is AuthFailure) {
            AppSnackBar.showError(
              context,
              GetLocalizedName.getLocalizedName(context, state.errorMessage),
            );
          }

          if (state is AuthSuccess) {
            final walletCompleter = Completer<void>();
            final categoryCompleter = Completer<void>();
            final budgetCompleter = Completer<void>();
            final transactionCompleter = Completer<void>();

            context.read<WalletBloc>().add(WalletStarted(completer: walletCompleter));
            context.read<CategoryBloc>().add(CategoryStarted(completer: categoryCompleter));
            context.read<BudgetBloc>().add(BudgetStarted(completer: budgetCompleter));
            context
                .read<TransactionBloc>()
                .add(TransactionStarted(completer: transactionCompleter));

            try {
              await walletCompleter.future;
              await categoryCompleter.future;
              await budgetCompleter.future;
              await transactionCompleter.future;

              if (context.mounted) {
                context.go(RoutePaths.home);
              }
            } catch (e) {
              debugPrint('Error: $e');
              if (context.mounted) {
                AppSnackBar.showError(
                  context,
                  GetLocalizedName.getLocalizedName(context, e.toString()),
                );
              }
            }
          }
        },
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 13,
                left: 11,
                child: Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFED50FF).withValues(alpha: 0.9),
                        blurRadius: 25,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const Text(
                'TMoney',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 56,
                  fontWeight: FontWeight.w700,
                  color: AppColors.light100,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
