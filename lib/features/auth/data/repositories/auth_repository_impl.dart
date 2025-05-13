import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:expense_tracker_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<Either> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final response = await authRemoteDataSource.loginWithEmailPassword(
      email: email,
      password: password,
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
  Future<Either> signUpWithEmailPassword({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final response = await authRemoteDataSource.signUpWithEmailPassword(
      fullName: fullName,
      email: email,
      password: password,
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
  Future<Either> getCurrentUser() async {
    final response = await authRemoteDataSource.getCurrentUser();
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
