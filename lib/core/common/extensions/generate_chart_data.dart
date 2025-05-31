import 'package:expense_tracker_app/core/common/extensions/currency_formatter.dart';
import 'package:expense_tracker_app/features/transaction/domain/entities/transaction_entity.dart';
import 'package:fl_chart/fl_chart.dart';

class GenerateChartData {
  GenerateChartData._();

  static Map<String, dynamic> generatePieChartData({
    required Map<String, List<TransactionEntity>> data,
  }) {
    final Map<String, dynamic> categories = {
      'income': [],
      'expense': [],
    };
    double totalIncome = 0;
    double totalExpense = 0;

    data.forEach((categoryId, transactions) {
      double totalAmountOfCategory = 0;

      for (var transaction in transactions) {
        totalAmountOfCategory += transaction.amount;
      }

      var type = 'expense';
      if (transactions.first.category.type == 0) {
        type = 'expense';
        totalExpense += totalAmountOfCategory;
      } else {
        type = 'income';
        totalIncome += totalAmountOfCategory;
      }

      categories[type]?.add({
        'category': transactions.first.category,
        'totalAmountOfCategory': totalAmountOfCategory,
      });
    });

    return {
      'income': {
        'categories': categories['income'],
        'totalAmount': totalIncome,
      },
      'expense': {
        'categories': categories['expense'],
        'totalAmount': totalExpense,
      },
    };
  }

  static Map<String, dynamic> generateLineChartData({
    required List<TransactionEntity> transactions,
    required String currency,
    required DateTime month,
  }) {
    if (month.month == DateTime.now().month &&
        month.year == DateTime.now().year) {
      month = DateTime.now();
    }

    final incomePerDay = List.filled(month.day, 0.0);
    final expensePerDay = List.filled(month.day, 0.0);

    double maxIncome = 0;
    double totalIncome = 0;
    double maxExpense = 0;
    double totalExpense = 0;

    for (var transaction in transactions) {
      if (transaction.createdAt.month == month.month &&
          transaction.createdAt.year == month.year) {
        final day = transaction.createdAt.day - 1;

        final amount = CurrencyFormatter.convertCurrency(
          amount: transaction.amount,
          fromCurrency: 'VND',
          toCurrency: currency,
        );

        if (transaction.category.type == 1) {
          incomePerDay[day] += amount;
          if (incomePerDay[day] > maxIncome) {
            maxIncome = incomePerDay[day];
          }
          totalIncome += amount;
        } else if (transaction.category.type == 0) {
          expensePerDay[day] += amount;
          if (expensePerDay[day] > maxExpense) {
            maxExpense = expensePerDay[day];
          }
          totalExpense += amount;
        }
      }
    }

    final incomeScaleFactorData = _findScaleFactor(maxAmount: maxIncome);
    final incomeScaleFactor = incomeScaleFactorData['scaleFactor'];
    final incomeSuffix = incomeScaleFactorData['suffix'];

    final expenseScaleFactorData = _findScaleFactor(maxAmount: maxExpense);
    final expenseScaleFactor = expenseScaleFactorData['scaleFactor'];
    final expenseSuffix = expenseScaleFactorData['suffix'];

    for (var i = 0; i < incomePerDay.length; i++) {
      incomePerDay[i] /= incomeScaleFactor;
    }

    for (var i = 0; i < expensePerDay.length; i++) {
      expensePerDay[i] /= expenseScaleFactor;
    }

    return {
      'income': <String, dynamic>{
        'flSpot': List.generate(
          month.day,
          (i) => FlSpot((i).toDouble(), incomePerDay[i]),
        ),
        'maxAmount': maxIncome,
        'scaleFactor': incomeScaleFactor,
        'suffix': incomeSuffix,
        'totalAmount': totalIncome,
      },
      'expense': <String, dynamic>{
        'flSpot': List.generate(
          month.day,
          (i) => FlSpot((i).toDouble(), expensePerDay[i]),
        ),
        'maxAmount': maxExpense,
        'scaleFactor': expenseScaleFactor,
        'suffix': expenseSuffix,
        'totalAmount': totalExpense,
      },
    };
  }

  static Map<String, dynamic> _findScaleFactor({
    required double maxAmount,
  }) {
    var scaleFactor = 1;
    var suffix = '';
    if (maxAmount >= 100000000) {
      scaleFactor = 100000000;
      suffix = '00M';
    } else if (maxAmount >= 10000000) {
      scaleFactor = 10000000;
      suffix = '0M';
    } else if (maxAmount >= 1000000) {
      scaleFactor = 1000000;
      suffix = 'M';
    } else if (maxAmount >= 100000) {
      scaleFactor = 100000;
      suffix = '00K';
    } else if (maxAmount >= 10000) {
      scaleFactor = 10000;
      suffix = '0K';
    } else if (maxAmount >= 1000) {
      scaleFactor = 1000;
      suffix = 'K';
    } else if (maxAmount >= 100) {
      scaleFactor = 100;
      suffix = '00';
    } else if (maxAmount >= 10) {
      scaleFactor = 10;
      suffix = '0';
    } else {
      scaleFactor = 1;
      suffix = '';
    }

    return {
      'scaleFactor': scaleFactor,
      'suffix': suffix,
    };
  }
}
