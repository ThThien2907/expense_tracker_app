import 'package:expense_tracker_app/core/common/widgets/app_bar/custom_app_bar.dart';
import 'package:expense_tracker_app/core/common/widgets/button/app_button.dart';
import 'package:expense_tracker_app/core/common/widgets/loading/loading.dart';
import 'package:expense_tracker_app/core/common/widgets/snack_bar/app_snack_bar.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/navigation/app_router.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker_app/features/auth/presentation/widgets/password_field.dart';
import 'package:expense_tracker_app/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode fullNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    fullNameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.singUp,
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
              if (state.errorMessage == 'No internet connection') {
                AppSnackBar.showError(
                    context, AppLocalizations.of(context)!.noInternetConnection);
              } else if (state.errorMessage == 'This email has existed') {
                AppSnackBar.showError(
                    context, AppLocalizations.of(context)!.emailExisted);
              }
              else {
                AppSnackBar.showError(context, state.errorMessage);
              }
            }
            if (state is AuthSuccess) {
              context.pushReplacement(RoutePaths.emailSent);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 56,
              ),
              TextFormField(
                focusNode: fullNameFocus,
                controller: fullNameController,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.fullName),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                focusNode: emailFocus,
                controller: emailController,
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
                height: 20,
              ),
              AppButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  fullNameFocus.unfocus();
                  emailFocus.unfocus();
                  passwordFocus.unfocus();
                  if (emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty &&
                      fullNameController.text.isNotEmpty) {
                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (emailRegex.hasMatch(emailController.text.trim())) {
                      if (passwordController.text.length >= 6) {
                        context.read<AuthBloc>().add(
                              AuthSignUp(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                fullName: fullNameController.text.trim(),
                                language: context.read<SettingBloc>().state.language,
                              ),
                            );
                      }
                      else {
                        AppSnackBar.showError(context, AppLocalizations.of(context)!.weakPassword);
                      }
                    }
                    else {
                      AppSnackBar.showError(context, AppLocalizations.of(context)!.invalidEmailFormat);
                    }
                  }
                  else {
                    AppSnackBar.showError(context, AppLocalizations.of(context)!.fillIn);
                  }
                },
                buttonText: AppLocalizations.of(context)!.singUp,
              ),
              const Spacer(),
              RichText(
                text: TextSpan(
                  text: AppLocalizations.of(context)!.alreadyHaveAnAccount,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: AppColors.light20,
                  ),
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.login,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: AppColors.violet100,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.violet100,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                        context.pushReplacement(RoutePaths.login);
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