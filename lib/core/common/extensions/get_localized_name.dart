import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:flutter/material.dart';

class GetLocalizedName {
  GetLocalizedName._();

  static String getLocalizedCategoryName(BuildContext context, String name) {
    final l10n = AppLocalizations.of(context)!;

    switch (name) {
      case "Food & Beverage":
        return l10n.categoryFoodBeverage;
      case "Bill & Utilities":
        return l10n.categoryBillUtilities;
      case "Shopping":
        return l10n.categoryShopping;
      case "Family":
        return l10n.categoryFamily;
      case "Transportation":
        return l10n.categoryTransportation;
      case "Health & Fitness":
        return l10n.categoryHealthFitness;
      case "Education":
        return l10n.categoryEducation;
      case "Entertainment":
        return l10n.categoryEntertainment;
      case "Investment":
        return l10n.categoryInvestment;
      case "Other Expense":
        return l10n.categoryOtherExpense;
      case "Outgoing transfer":
        return l10n.categoryOutgoingTransfer;
      case "Pay Interest":
        return l10n.categoryPayInterest;
      case "Loan":
        return l10n.categoryLoan;
      case "Repayment":
        return l10n.categoryRepayment;
      case "Expense Uncategorized":
        return l10n.categoryExpenseUncategorized;

      case "Salary":
        return l10n.categorySalary;
      case "Other Income":
        return l10n.categoryOtherIncome;
      case "Incoming transfer":
        return l10n.categoryIncomingTransfer;
      case "Collect Interest":
        return l10n.categoryCollectInterest;
      case "Debt":
        return l10n.categoryDebt;
      case "Debt Collection":
        return l10n.categoryDebtCollection;
      case "Income Uncategorized":
        return l10n.categoryIncomeUncategorized;

      default:
        return name;
    }
  }

}