import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/network/connection_checker.dart';
import 'package:expense_tracker_app/features/transaction/data/models/transaction_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class TransactionRemoteDatasource {
  Future<Either> loadTransactions();

  Future<Either> addNewTransaction({
    required String categoryId,
    required String walletId,
    required double amount,
    required String description,
    required DateTime createdAt,
  });

  Future<Either> editTransaction({
    required String transactionId,
    required String categoryId,
    required String walletId,
    required double amount,
    required String description,
    required DateTime createdAt,
  });

  Future<Either> deleteTransaction({
    required String transactionId,
  });
}

class TransactionRemoteDatasourceImpl implements TransactionRemoteDatasource {
  final SupabaseClient supabaseClient;
  final ConnectionChecker connectionChecker;

  TransactionRemoteDatasourceImpl(this.supabaseClient, this.connectionChecker);

  @override
  Future<Either> loadTransactions() async {
    try {
      if (!await (connectionChecker.hasInternetConnection())) {
        return const Left('No internet connection');
      }

      final user = supabaseClient.auth.currentUser!;

      final response = await supabaseClient
          .from('transactions')
          .select('*, categories(*)')
          .eq('user_id', user.id).order('created_at');

      return Right(response.map((e) => TransactionModel.fromMap(e)).toList());
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> addNewTransaction({
    required String categoryId,
    required String walletId,
    required double amount,
    required String description,
    required DateTime createdAt,
  }) async {
    try {
      if (!await (connectionChecker.hasInternetConnection())) {
        return const Left('No internet connection');
      }
      final user = supabaseClient.auth.currentUser!;

      final response = await supabaseClient.rpc(
        'create_new_transaction',
        params: ({
          'p_category_id': categoryId,
          'p_user_id': user.id,
          'p_wallet_id': walletId,
          'p_amount': amount,
          'p_description': description,
          'p_created_at': createdAt.toUtc().toIso8601String(),
        }),
      ) as Map<String, dynamic>;

      if (response.isNotEmpty) {
        return Right(response);
      }
      return const Left('Failure, please try again later');
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> editTransaction({
    required String transactionId,
    required String categoryId,
    required String walletId,
    required double amount,
    required String description,
    required DateTime createdAt,
  }) async {
    try {
      if (!await (connectionChecker.hasInternetConnection())) {
        return const Left('No internet connection');
      }
      final user = supabaseClient.auth.currentUser!;

      final response = await supabaseClient.rpc(
        'update_transaction',
        params: ({
          'p_transaction_id': transactionId,
          'p_category_id': categoryId,
          'p_wallet_id': walletId,
          'p_user_id': user.id,
          'p_amount': amount,
          'p_description': description,
          'p_created_at': createdAt.toUtc().toIso8601String(),
        }),
      ) as Map<String, dynamic>;

      return Right(response);
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> deleteTransaction({
    required String transactionId,
  }) async {
    try {
      if (!await (connectionChecker.hasInternetConnection())) {
        return const Left('No internet connection');
      }

      final response = await supabaseClient.rpc(
        'delete_transaction',
        params: ({
          'p_transaction_id': transactionId,
        }),
      );
      return Right(response);
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
