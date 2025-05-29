import 'package:expense_tracker_app/features/wallet/domain/entities/wallet_entity.dart';

class WalletModel extends WalletEntity {
  WalletModel({
    required super.walletId,
    required super.name,
    required super.balance,
    required super.userId,
    required super.type,
    required super.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'wallet_id': walletId,
      'name': name,
      'balance': balance,
      'user_id': userId,
      'type': type,
      'createdAt': createdAt,
    };
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      walletId: map['wallet_id'],
      name: map['name'],
      balance: (map['balance'] as num).toDouble(),
      userId: map['user_id'],
      type: map['type'] as int,
      createdAt: DateTime.parse(map['created_at']).toLocal(),
    );
  }
}
