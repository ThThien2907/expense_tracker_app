import 'dart:async';

import 'package:expense_tracker_app/core/assets/app_vectors.dart';
import 'package:expense_tracker_app/core/common/extensions/get_localized_name.dart';
import 'package:expense_tracker_app/core/common/widgets/app_bar/custom_app_bar.dart';
import 'package:expense_tracker_app/core/common/widgets/button/app_button.dart';
import 'package:expense_tracker_app/core/common/widgets/loading/loading.dart';
import 'package:expense_tracker_app/core/common/widgets/snack_bar/app_snack_bar.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/navigation/app_router.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker_app/features/auth/presentation/widgets/password_field.dart';
import 'package:expense_tracker_app/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:expense_tracker_app/features/category/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker_app/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:expense_tracker_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker_app/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          listener: (context, state) async {
            if (state is AuthLoading) {
              Loading.show(context);
            }
            if (state is AuthFailure) {
              Loading.hide(context);
              if (state.errorMessage == 'No internet connection') {
                AppSnackBar.showError(context, AppLocalizations.of(context)!.noInternetConnection);
              } else if (state.errorMessage == 'This email has existed') {
                AppSnackBar.showError(context, AppLocalizations.of(context)!.emailExisted);
              } else if (state.errorMessage.isEmpty) {

              } else {
                AppSnackBar.showError(context, state.errorMessage);
              }
            }
            if (state is AuthSuccess) {
              if (state.provider == 'google') {
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
              } else {
                if (context.mounted) {
                  context.pushReplacement(RoutePaths.emailSent);
                }
              }
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
                decoration: InputDecoration(hintText: AppLocalizations.of(context)!.fullName),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                focusNode: emailFocus,
                controller: emailController,
                decoration: InputDecoration(hintText: AppLocalizations.of(context)!.email),
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
                                language: context.read<SettingBloc>().state.setting.language,
                              ),
                            );
                      } else {
                        AppSnackBar.showError(context, AppLocalizations.of(context)!.weakPassword);
                      }
                    } else {
                      AppSnackBar.showError(
                          context, AppLocalizations.of(context)!.invalidEmailFormat);
                    }
                  } else {
                    AppSnackBar.showError(context, AppLocalizations.of(context)!.fillIn);
                  }
                },
                buttonText: AppLocalizations.of(context)!.singUp,
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Divider(
                      indent: 20,
                      endIndent: 20,
                      color: AppColors.light40,
                      thickness: 2,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.or,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.light20,
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      indent: 20,
                      endIndent: 20,
                      color: AppColors.light40,
                      thickness: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              AppButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                    AuthLoginWithGoogle(
                      language: context.read<SettingBloc>().state.setting.language,
                    ),
                  );
                },
                buttonColor: AppColors.light100,
                textColor: AppColors.dark75,
                borderSide: const BorderSide(
                  color: AppColors.light40,
                  width: 2,
                ),
                widget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppVectors.googleIcon,
                      height: 24,
                    ),
                    const SizedBox(width: 16,),
                    Text(
                      AppLocalizations.of(context)!.signInWithGoogle,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.dark75,
                      ),
                    ),
                  ],
                ),
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
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
