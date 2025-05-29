import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/network/connection_checker.dart';
import 'package:expense_tracker_app/features/wallet/data/models/wallet_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class WalletRemoteDatasource {
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

class WalletRemoteDatasourceImpl implements WalletRemoteDatasource {
  final SupabaseClient supabaseClient;
  final ConnectionChecker connectionChecker;

  WalletRemoteDatasourceImpl(
    this.supabaseClient,
    this.connectionChecker,
  );

  @override
  Future<Either> loadWallets() async {
    try {
      if (!await (connectionChecker.hasInternetConnection())) {
        return const Left('No internet connection');
      }
      final user = supabaseClient.auth.currentUser!;

      final response =
          await supabaseClient.from('wallets').select().eq('user_id', user.id);

      return Right(response.map((e) => WalletModel.fromMap(e)).toList());
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> addNewWallet({
    required String name,
    required double balance,
    required int type,
  }) async {
    try {
      if (!await (connectionChecker.hasInternetConnection())) {
        return const Left('No internet connection');
      }

      final user = supabaseClient.auth.currentUser!;

      final response = await supabaseClient.rpc(
        'create_new_wallet',
        params: ({
          'p_name': name,
          'p_balance': balance,
          'p_user_id': user.id,
          'p_type': type,
        }),
      );

      return Right(response);
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> editWallet({
    required String walletId,
    required String name,
    required double balance,
    required int type,
  }) async {
    try {
      if (!await (connectionChecker.hasInternetConnection())) {
        return const Left('No internet connection');
      }

      final response = await supabaseClient.rpc(
        'update_wallet',
        params: ({
          'p_wallet_id': walletId,
          'p_name': name,
          'p_balance': balance,
          'p_type': type
        }),
      );

      return Right(response);
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> deleteWallet({required String walletId}) async {
    try {
      if (!await (connectionChecker.hasInternetConnection())) {
        return const Left('No internet connection');
      }

      await supabaseClient.rpc(
        'delete_wallet',
        params: ({
          'p_wallet_id': walletId,
        }),
      );

      return const Right('Delete Success');
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
