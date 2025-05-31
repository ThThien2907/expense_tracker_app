import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class MonthPickerButton extends StatelessWidget {
  const MonthPickerButton({
    super.key,
    required this.initialDate, required this.onTap,
  });

  final DateTime initialDate;
  final Function(DateTime) onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () {
          showMonthPicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(2024),
            lastDate: DateTime.now(),
          ).then((date) {
            if (date != null && date != initialDate) {
              onTap(date);
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.only(left: 14, right: 8),
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
              Text(
                DateFormat('MM/yyyy').format(initialDate),
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.dark50),
              ),
              const SizedBox(
                width: 4,
              ),
              const Icon(
                Icons.keyboard_arrow_down_sharp,
                size: 24,
                color: AppColors.violet100,
              )
            ],
          ),
        ),
      ),
    );
  }
}
