import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/network/connection_checker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SettingRemoteDatasource {
  Future<Either> loadCurrentUserSettings();

  Future<Either> updateLanguage({
    required String language,
    required String userId,
  });

  Future<Either> updateCurrency({
    required String currency,
    required String userId,
  });
}

class SettingRemoteDatasourceImpl implements SettingRemoteDatasource {
  final SupabaseClient supabaseClient;
  final ConnectionChecker connectionChecker;

  SettingRemoteDatasourceImpl(this.supabaseClient, this.connectionChecker);

  @override
  Future<Either> loadCurrentUserSettings() async {
    try {
      if (!await (connectionChecker.hasInternetConnection())) {
        return const Left('No internet connection');
      }

      final session = supabaseClient.auth.currentSession;
      if (session != null) {
        final response = await supabaseClient
            .from('settings')
            .select()
            .eq('user_id', session.user.id);
        return Right(response);
      }

      return const Left('No data');
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> updateLanguage({
    required String language,
    required String userId,
  }) async {
    try {
      if (!await (connectionChecker.hasInternetConnection())) {
        return const Left('No internet connection');
      }
      final response = await supabaseClient
          .from('settings')
          .update(({
            'language': language,
          }))
          .eq('user_id', userId)
          .select();
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
  Future<Either> updateCurrency({
    required String currency,
    required String userId,
  }) async {
    try {
      if (!await (connectionChecker.hasInternetConnection())) {
        return const Left('No internet connection');
      }
      final response = await supabaseClient
          .from('settings')
          .update(({
            'currency': currency,
          }))
          .eq('user_id', userId)
          .select();
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
}
