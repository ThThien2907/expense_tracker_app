import 'package:expense_tracker_app/core/common/widgets/button/app_button.dart';
import 'package:expense_tracker_app/core/common/widgets/loading/loading.dart';
import 'package:expense_tracker_app/core/common/widgets/snack_bar/app_snack_bar.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/navigation/app_router.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker_app/features/auth/presentation/widgets/password_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.login,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              Loading.show(context);
            } else {
              Loading.hide(context);
            }
            if (state is AuthFailure) {
              if (state.errorMessage == 'Email not confirmed') {
                AppSnackBar.showError(context, AppLocalizations.of(context)!.emailNotConfirmed);
              } else if (state.errorMessage == 'Invalid login credentials') {
                AppSnackBar.showError(context, AppLocalizations.of(context)!.invalidLoginCredentials);
              } else {
                AppSnackBar.showError(context, state.errorMessage);
              }
            }
            if (state is AuthSuccess) {
              context.go(RoutePaths.home);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 56,
              ),
              TextFormField(
                focusNode: emailFocus,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.email),
              ),
              const SizedBox(
                height: 16,
              ),
              PasswordField(
                focusNode: passwordFocus,
                passwordController: passwordController,
              ),
              const SizedBox(
                height: 40,
              ),
              AppButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    emailFocus.unfocus();
                    passwordFocus.unfocus();

                    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (emailRegex.hasMatch(emailController.text.trim())){
                        context.read<AuthBloc>().add(
                          AuthLogin(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          ),
                        );
                      }
                      else {
                        AppSnackBar.showError(context, AppLocalizations.of(context)!.invalidEmailFormat);
                      }
                    }
                    else {
                      AppSnackBar.showError(context, AppLocalizations.of(context)!.fillIn);
                    }
                  },
                  buttonText: AppLocalizations.of(context)!.login),
              const SizedBox(
                height: 32,
              ),
              // TextButton(
              //   onPressed: () {},
              //   child: Text(
              //     AppLocalizations.of(context)!.forgotPassword,
              //     style: TextStyle(
              //       fontFamily: 'Inter',
              //       fontSize: 18,
              //       fontWeight: FontWeight.w500,
              //       color: AppColors.violet100,
              //     ),
              //   ),
              // ),
              const Spacer(),
              RichText(
                text: TextSpan(
                  text: AppLocalizations.of(context)!.dontHaveAnAccount,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: AppColors.light20,
                  ),
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.singUp,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: AppColors.violet100,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.violet100,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.pushReplacement(RoutePaths.signUp);
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
