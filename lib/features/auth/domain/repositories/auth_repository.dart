import 'package:dartz/dartz.dart';

abstract class AuthRepository {
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
}
