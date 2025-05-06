import 'package:expense_tracker_app/core/common/widgets/snack_bar/app_snack_bar.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/navigation/app_router.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/auth/presentation/bloc/auth_bloc.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.violet100,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if(state is AuthInitial) {
            context.go(RoutePaths.onboarding);
          }

          if (state is AuthSuccess) {
            context.go(RoutePaths.home);
          }

          if (state is AuthFailure){
            if (state.errorMessage == 'No internet connection') {
              AppSnackBar.showError(
                  context, AppLocalizations.of(context)!.noInternetConnection);
            }
            else {
              AppSnackBar.showError(context, state.errorMessage);
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
