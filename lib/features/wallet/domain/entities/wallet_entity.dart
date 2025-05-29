class WalletEntity {
  final String walletId;
  final String name;
  double balance;
  final String userId;
  final int type;
  final DateTime createdAt;

  WalletEntity({
    required this.walletId,
    required this.name,
    required this.balance,
    required this.userId,
    required this.type,
    required this.createdAt,
  });
}
