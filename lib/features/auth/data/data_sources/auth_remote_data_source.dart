import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/network/connection_checker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<Either> signUpWithEmailPassword({
    required String fullName,
    required String language,
    required String email,
    required String password,
  });

  Future<Either> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either> getCurrentUser();

  Future<Either> loginWithGoogle({
    required String language,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  final GoogleSignIn googleSignIn;
  final ConnectionChecker connectionChecker;

  AuthRemoteDataSourceImpl(
    this.supabaseClient,
    this.googleSignIn,
    this.connectionChecker,
  );

  @override
  Future<Either> signUpWithEmailPassword({
    required String fullName,
    required String language,
    required String email,
    required String password,
  }) async {
    try {
      if (!await (connectionChecker.hasInternetConnection())) {
        return const Left('No internet connection');
      }
      final user = await supabaseClient.from('users').select().eq('email', email);
      if (user.isNotEmpty) {
        return const Left('This email has existed');
      }
      await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          'full_name': fullName,
          'language': language,
        },
      );
      return const Right('Sign Up Success');
    } on AuthException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (!await (connectionChecker.hasInternetConnection())) {
        return const Left('No internet connection');
      }
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return const Left('User is null');
      }
      final user = await supabaseClient
          .from('users')
          .select('*, settings(*)')
          .eq('user_id', response.user!.id);
      return Right(user);
    } on AuthException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getCurrentUser() async {
    try {
      if (!await (connectionChecker.hasInternetConnection())) {
        return const Left('No internet connection');
      }
      var currentUserSession = supabaseClient.auth.currentSession;
      if (currentUserSession != null) {
        final response = await supabaseClient
            .from('users')
            .select('*, settings(*)')
            .eq('user_id', currentUserSession.user.id);
        return Right(response);
      } else {
        return const Right(null);
      }
    } on AuthException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> loginWithGoogle({
    required String language,
  }) async {
    try {
      final googleUser = await googleSignIn.signIn();
      if(googleUser == null) {
        return const Left('');
      }
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;
      if (accessToken == null) {
        return const Left('No Access Token found');
      }
      if (idToken == null) {
        return const Left('No ID Token found');
      }
      final userResponse = await supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (userResponse.user != null) {
        final userData = await supabaseClient
            .from('users')
            .select('*, settings(*)')
            .eq('user_id', userResponse.user!.id);

        bool isUserDataUpdated = false;

        if (userData.first['settings'].first['language'] == null) {
          await supabaseClient.from('settings').update({
            'language': language,
          }).eq('user_id', userResponse.user!.id);
          isUserDataUpdated = true;
        }

        if(userData.first['avatar'] == null){
          await supabaseClient.from('users').update({
            'avatar': userResponse.user!.userMetadata!['avatar_url'],
          }).eq('user_id', userResponse.user!.id);
          isUserDataUpdated = true;
        }
        if(isUserDataUpdated){
          final newUserData = await supabaseClient
              .from('users')
              .select('*, settings(*)')
              .eq('user_id', userResponse.user!.id);
          return Right(newUserData);
        }

        return Right(userData);
      }
      return const Left('Failure, please try again later');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
