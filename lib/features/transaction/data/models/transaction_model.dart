import 'package:expense_tracker_app/features/category/data/models/category_model.dart';
import 'package:expense_tracker_app/features/transaction/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    required super.transactionId,
    required super.categoryId,
    required super.walletId,
    required super.userId,
    required super.description,
    required super.createdAt,
    required super.amount,
    required CategoryModel super.category,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transaction_id': transactionId,
      'category_id': categoryId,
      'wallet_id': walletId,
      'user_id': userId,
      'description': description,
      'created_at': createdAt,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      transactionId: map['transaction_id'],
      categoryId: map['category_id'],
      walletId: map['wallet_id'],
      userId: map['user_id'],
      description: map['description'] ?? '',
      createdAt: DateTime.parse(map['created_at']).toLocal(),
      amount: (map['amount'] as num).toDouble(),
      category: CategoryModel.fromMap(map['categories']),
    );
  }
}
