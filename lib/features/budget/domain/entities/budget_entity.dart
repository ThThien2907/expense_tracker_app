import 'package:expense_tracker_app/features/category/domain/entities/category_entity.dart';

class BudgetEntity {
  final String budgetId;
  final String categoryId;
  final String userId;
  final DateTime createdAt;
  final double amountLimit;
  final double amountSpent;
  final DateTime startDate;
  final DateTime endDate;
  final CategoryEntity category;

  BudgetEntity({
    required this.budgetId,
    required this.categoryId,
    required this.userId,
    required this.createdAt,
    required this.amountLimit,
    required this.amountSpent,
    required this.startDate,
    required this.endDate,
    required this.category,
  });
}
