import 'package:expense_tracker_app/core/assets/app_images.dart';
import 'package:expense_tracker_app/core/common/widgets/button/app_button.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/navigation/app_router.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmailSentPage extends StatelessWidget {
  const EmailSentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 70,
            ),
            Image.asset(AppImages.emailSent),
            const SizedBox(
              height: 16,
            ),
            Text(
              AppLocalizations.of(context)!.emailSent,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.dark100,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              AppLocalizations.of(context)!.checkYourEmail,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: AppColors.dark25,
              ),
            ),
            const Spacer(),
            AppButton(
              onPressed: () {
                context.pushReplacement(RoutePaths.login);
              },
              buttonText: AppLocalizations.of(context)!.backToLogin,
            ),
          ],
        ),
      ),
    );
  }
}
