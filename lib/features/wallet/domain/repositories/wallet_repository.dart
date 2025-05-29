import 'package:dartz/dartz.dart';

abstract class WalletRepository {
  Future<Either> loadWallets();

  Future<Either> addNewWallet({
    required String name,
    required double balance,
    required int type,
  });

  Future<Either> editWallet({
    required String walletId,
    required String name,
    required double balance,
    required int type,
  });

  Future<Either> deleteWallet({
    required String walletId,
  });
}
