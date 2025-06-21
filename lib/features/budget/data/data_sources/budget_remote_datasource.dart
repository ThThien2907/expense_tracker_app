import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/network/connection_checker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class BudgetRemoteDatasource {
  Future<Either> loadBudgets();

  Future<Either> addNewBudget({
    required String categoryId,
    required double amountLimit,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Either> editBudget({
    required String budgetId,
    required String categoryId,
    required double amountLimit,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Either> deleteBudget({
    required String budgetId,
  });
}

class BudgetRemoteDatasourceImpl implements BudgetRemoteDatasource {
  final SupabaseClient supabaseClient;
  final ConnectionChecker connectionChecker;

  BudgetRemoteDatasourceImpl(this.supabaseClient, this.connectionChecker);

  @override
  Future<Either> loadBudgets() async {
    try {
      if (!await (connectionChecker.hasInternetConnection())) {
        return const Left('No internet connection');
      }

      final user = supabaseClient.auth.currentUser;

      final response = await supabaseClient
          .from('budgets')
          .select('*, categories(*)')
          .eq('user_id', user!.id)
          .order('created_at', ascending: false);

      return Right(response);
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> addNewBudget({
    required String categoryId,
    required double amountLimit,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      if (!await (connectionChecker.hasInternetConnection())) {
        return const Left('No internet connection');
      }
      final user = supabaseClient.auth.currentUser!;

      final transactionResponse = await supabaseClient
          .from('transactions')
          .select()
          .eq('user_id', user.id)
          .eq('category_id', categoryId)
          .gte('created_at', startDate.toUtc().toIso8601String())
          .lte('created_at', endDate.toUtc().toIso8601String());

      double amountSpent = 0;
      if (transactionResponse.isNotEmpty) {
        for (var map in transactionResponse) {
          amountSpent += (map['amount'] as num).toDouble();
        }
      }

      final response = await supabaseClient
          .from('budgets')
          .insert(({
            'category_id': categoryId,
            'user_id': user.id,
            'amount_limit': amountLimit,
            'amount_spent': amountSpent,
            'start_date': startDate.toUtc().toIso8601String(),
            'end_date': endDate.toUtc().toIso8601String(),
          }))
          .select('*, categories(*)');

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
  Future<Either> editBudget({
    required String budgetId,
    required String categoryId,
    required double amountLimit,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      if (!await (connectionChecker.hasInternetConnection())) {
        return const Left('No internet connection');
      }
      final user = supabaseClient.auth.currentUser!;

      final transactionResponse = await supabaseClient
          .from('transactions')
          .select()
          .eq('user_id', user.id)
          .eq('category_id', categoryId)
          .gte('created_at', startDate.toUtc().toIso8601String())
          .lte('created_at', endDate.toUtc().toIso8601String());

      double amountSpent = 0;
      if (transactionResponse.isNotEmpty) {
        for (var map in transactionResponse) {
          amountSpent += (map['amount'] as num).toDouble();
        }
      }

      final response = await supabaseClient
          .from('budgets')
          .update(({
            'category_id': categoryId,
            'amount_limit': amountLimit,
            'amount_spent': amountSpent,
            'start_date': startDate.toUtc().toIso8601String(),
            'end_date': endDate.toUtc().toIso8601String(),
          }))
          .eq('budget_id', budgetId)
          .select('*, categories(*)');

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
  Future<Either> deleteBudget({
    required String budgetId,
  }) async {
    try {
      if (!await (connectionChecker.hasInternetConnection())) {
        return const Left('No internet connection');
      }

      final response = await supabaseClient
          .from('budgets')
          .delete()
          .eq('budget_id', budgetId)
          .select();

      if (response.isNotEmpty) {
        return const Right('Delete Success');
      }
      return const Left('Failure, please try again later');
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
