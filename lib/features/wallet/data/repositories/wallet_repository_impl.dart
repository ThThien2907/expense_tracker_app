import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/features/transaction/data/models/transaction_model.dart';
import 'package:expense_tracker_app/features/wallet/data/data_sources/wallet_remote_datasource.dart';
import 'package:expense_tracker_app/features/wallet/data/models/wallet_model.dart';
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
        List<Map<String, dynamic>> response = ifRight;
        return Right(response.map((e) => WalletModel.fromMap(e)).toList());
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
        Map<String, dynamic> response = ifRight;
        print(response.toString());
        final wallet = WalletModel.fromMap(response['wallet']);
        final transaction = response['transaction'] != null
            ? TransactionModel.fromMap(response['transaction'])
            : null;
        return Right(<String, dynamic>{'wallet': wallet, 'transaction': transaction});
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
        Map<String, dynamic> response = ifRight;
        final wallet = WalletModel.fromMap(response['wallet']);
        final transaction = response['transaction'] != null
            ? TransactionModel.fromMap(response['transaction'])
            : null;
        return Right(<String, dynamic>{'wallet': wallet, 'transaction': transaction});
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
