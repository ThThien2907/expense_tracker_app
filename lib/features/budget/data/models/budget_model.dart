import 'package:expense_tracker_app/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_tracker_app/features/category/data/models/category_model.dart';

class BudgetModel extends BudgetEntity {
  BudgetModel({
    required super.budgetId,
    required super.categoryId,
    required super.userId,
    required super.createdAt,
    required super.amountLimit,
    required super.amountSpent,
    required super.startDate,
    required super.endDate,
    required CategoryModel super.category,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'budget_id': budgetId,
      'category_id': categoryId,
      'user_id': userId,
      'created_at': createdAt,
      'amount_limit': amountLimit,
      'amount_spent': amountSpent,
      'start_date': startDate,
      'end_date': endDate,
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      budgetId: map['budget_id'],
      categoryId: map['category_id'],
      userId: map['user_id'],
      createdAt: DateTime.parse(map['created_at']).toLocal(),
      amountLimit: (map['amount_limit'] as num).toDouble(),
      amountSpent: (map['amount_spent'] as num).toDouble(),
      startDate: DateTime.parse(map['start_date']).toLocal(),
      endDate: DateTime.parse(map['end_date']).toLocal(),
      category: CategoryModel.fromMap(map['categories']),
    );
  }
}
