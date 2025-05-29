import 'package:expense_tracker_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:expense_tracker_app/core/common/extensions/get_localized_name.dart';
import 'package:expense_tracker_app/core/common/widgets/button/app_button.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/navigation/app_router.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:expense_tracker_app/features/onboarding/presentation/widgets/onboarding_page_view.dart';
import 'package:expense_tracker_app/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:expense_tracker_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker_app/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = context.read<SettingBloc>().state.setting.language;
    if (context.read<AppUserCubit>().state != null) {
      context.read<AppUserCubit>().clearUser();
      context.read<SettingBloc>().add(ClearSettings());
      context.read<WalletBloc>().add(ClearWallets());
      context.read<BudgetBloc>().add(ClearBudgets());
      context.read<TransactionBloc>().add(ClearTransactions());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: OnboardingPageView(pageController: _pageController),
              ),
              const SizedBox(
                height: 16,
              ),
              SmoothPageIndicator(
                controller: _pageController,
                count: 3,
                effect: const ExpandingDotsEffect(
                  activeDotColor: AppColors.violet100,
                  dotColor: AppColors.light40,
                  dotWidth: 10,
                  dotHeight: 10,
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppButton(
                  onPressed: () {
                    context.push(RoutePaths.signUp);
                  },
                  buttonText: AppLocalizations.of(context)!.singUp,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppButton(
                  onPressed: () {
                    context.push(RoutePaths.login);
                  },
                  buttonText: AppLocalizations.of(context)!.login,
                  buttonColor: AppColors.violet20,
                  textColor: AppColors.violet100,
                ),
              ),
              const SizedBox(
                height: 24,
              )
            ],
          ),
          Positioned(
            right: 20,
            top: 55,
            child: PopupMenuButton(
              borderRadius: BorderRadius.circular(30),
              initialValue: selectedValue,
              onSelected: _onSelected,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'en',
                  child: Text(AppLocalizations.of(context)!.english),
                ),
                PopupMenuItem(
                  value: 'vi',
                  child: Text(AppLocalizations.of(context)!.vietnamese),
                ),
              ],
              child: Container(
                padding: const EdgeInsets.only(left: 6, right: 12),
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      width: 2,
                      color: AppColors.light60,
                    )),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.language,
                      size: 24,
                      color: AppColors.violet100,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      GetLocalizedName.getLocalizedName(
                        context,
                        selectedValue,
                      ),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.dark50,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onSelected(String value) {
    setState(() {
      selectedValue = value;
      context.read<SettingBloc>().add(SettingLanguageChanged(language: value));
    });
  }
}
