import 'package:expense_tracker_app/core/common/widgets/button/app_button.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/navigation/app_router.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/onboarding/presentation/widgets/onboarding_page_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
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
    );
  }
}
