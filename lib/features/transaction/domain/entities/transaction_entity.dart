import 'package:expense_tracker_app/features/category/domain/entities/category_entity.dart';

class TransactionEntity {
  final String transactionId;
  final String walletId;
  final String userId;
  final String description;
  final DateTime createdAt;
  final String categoryId;
  final double amount;
  final CategoryEntity category;

  TransactionEntity({
    required this.transactionId,
    required this.categoryId,
    required this.walletId,
    required this.userId,
    required this.description,
    required this.createdAt,
    required this.amount,
    required this.category,
  });
}
