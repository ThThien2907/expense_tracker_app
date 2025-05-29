import 'package:expense_tracker_app/core/common/extensions/get_localized_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final dateFormat = DateFormat('dd/MM/yyyy');
  static final weekdayFormat = DateFormat.EEEE();

  static String formatDateLabel(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final target = DateTime(date.year, date.month, date.day);

    var weekday = weekdayFormat.format(date);
    final formattedDate = dateFormat.format(date);

    if (target == today) weekday = 'Today';
    if (target == yesterday) weekday = 'Yesterday';

    return '${GetLocalizedName.getLocalizedName(context, weekday)}, $formattedDate';
  }
}