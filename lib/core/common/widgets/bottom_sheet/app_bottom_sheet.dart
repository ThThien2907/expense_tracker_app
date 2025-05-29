import 'package:expense_tracker_app/core/common/widgets/button/app_button.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppBottomSheet {
  static Future<void> show({
    required BuildContext context,
    required Widget widget,
    double? height,
    EdgeInsets? padding,
  }) {
    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      backgroundColor: AppColors.light100,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.light100,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          padding: padding ?? const EdgeInsets.only(left: 16, right: 16, bottom: 32),
          width: MediaQuery.of(context).size.width,
          height: height,
          child: widget,
        );
      },
    );
  }
}

class ConfirmEventBottomSheet extends StatelessWidget {
  const ConfirmEventBottomSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPressedYesButton,
  });

  final VoidCallback onPressedYesButton;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            color: AppColors.dark100,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: AppColors.light20,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 32,
        ),
        Row(
          children: [
            Expanded(
              child: AppButton(
                onPressed: (){
                  Navigator.of(context, rootNavigator: true).pop();
                },
                buttonText: AppLocalizations.of(context)!.no,
                textColor: AppColors.violet100,
                buttonColor: AppColors.violet20,
                height: 60,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: AppButton(
                onPressed: onPressedYesButton,
                buttonText: AppLocalizations.of(context)!.yes,
                textColor: AppColors.light100,
                buttonColor: AppColors.violet100,
                height: 60,
              ),
            ),
          ],
        )
      ],
    );
  }
}
