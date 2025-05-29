import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/features/wallet/data/data_sources/wallet_remote_datasource.dart';
import 'package:expense_tracker_app/features/wallet/domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDatasource walletRemoteDatasource;

  WalletRepositoryImpl(this.walletRemoteDatasource);

  @override
  Future<Either> loadWallets() async {
    final response = await walletRemoteDatasource.loadWallets();
    return response.fold(
      (ifLeft) {
        return Left(ifLeft);
      },
      (ifRight) {
        return Right(ifRight);
      },
    );
  }

  @override
  Future<Either> addNewWallet({
    required String name,
    required double balance,
    required int type,
  }) async {
    final response = await walletRemoteDatasource.addNewWallet(
      name: name,
      balance: balance,
      type: type,
    );
    return response.fold(
      (ifLeft) {
        return Left(ifLeft);
      },
      (ifRight) {
        return Right(ifRight);
      },
    );
  }

  @override
  Future<Either> editWallet({
    required String walletId,
    required String name,
    required double balance,
    required int type,
  }) async {
    final response = await walletRemoteDatasource.editWallet(
      walletId: walletId,
      name: name,
      balance: balance,
      type: type,
    );
    return response.fold(
          (ifLeft) {
        return Left(ifLeft);
      },
          (ifRight) {
        return Right(ifRight);
      },
    );
  }

  @override
  Future<Either> deleteWallet({required String walletId}) async {
    final response = await walletRemoteDatasource.deleteWallet(
      walletId: walletId,
    );
    return response.fold(
          (ifLeft) {
        return Left(ifLeft);
      },
          (ifRight) {
        return Right(ifRight);
      },
    );
  }
}
