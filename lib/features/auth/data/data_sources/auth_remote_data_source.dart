import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/network/connection_checker.dart';
import 'package:expense_tracker_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<Either> signUpWithEmailPassword({
    required String fullName,
    required String email,
    required String password,
  });

  Future<Either> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either> getCurrentUser();

  Future<void> logOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  final ConnectionChecker connectionChecker;

  AuthRemoteDataSourceImpl(
    this.supabaseClient,
    this.connectionChecker,
  );

  @override
  Future<Either> signUpWithEmailPassword({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      if(!await (connectionChecker.hasInternetConnection())){
        return Left('No internet connection');
      }
      final user =
          await supabaseClient.from('users').select().eq('email', email);
      if (user.isNotEmpty) {
        return Left('This email has existed');
      }
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {'full_name': fullName},
      );

      print(response.user!.toJson().toString());
      return Right('Sign Up Success');
    } on AuthException catch (e) {
      print('left');
      print(e.toString());
      print(e.code.toString());
      return Left(e.message);
    } catch (e) {
      print(e.toString());
      return Left(e.toString());
    }
  }

  @override
  Future<Either> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      if(!await (connectionChecker.hasInternetConnection())){
        return Left('No internet connection');
      }
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        print('User is null');
        return Left('User is null');
      }
      print(response.user!.toJson().toString());
      final user = await supabaseClient.from('users').select().eq(
            'user_id',
            response.user!.id,
          );
      print(UserModel.fromMap(user.first).userId);
      return Right(UserModel.fromMap(user.first));
      // print(UserModel.fromMap(response.user!.toJson()).toString());
      // return Right(response.user!.toJson());
    } on AuthException catch (e) {
      print(e.toString());
      return Left(e.message);
    } catch (e) {
      print(e.toString());
      return Left(e.toString());
    }
  }

  @override
  Future<void> logOut() async {
    if (supabaseClient.auth.currentSession != null) {
      await supabaseClient.auth.signOut();
    }
  }

  @override
  Future<Either> getCurrentUser() async {
    try {
      if(!await (connectionChecker.hasInternetConnection())){
        return Left('No internet connection');
      }
      var currentUserSession = supabaseClient.auth.currentSession;
      if (currentUserSession != null) {
        final response = await supabaseClient.from('users').select().eq(
              'user_id',
              currentUserSession.user.id,
            );
        print(UserModel.fromMap(response.first).userId);
        return Right(UserModel.fromMap(response.first));
      } else {
        print('null data');
        return Right(null);
      }
      //
      // if (response.user == null) {
      //   print('User is null');
      //   return Left('User is null');
      // }
      // print(response.user!.toJson().toString());
      // return Right(response.user!.toJson());
    } on AuthException catch (e) {
      return Left(e.message);
    } catch (e) {
      print(e.toString());
      return Left(e.toString());
    }
  }
}
