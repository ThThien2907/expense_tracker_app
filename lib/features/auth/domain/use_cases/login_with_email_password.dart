import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/usecase/usecase.dart';
import 'package:expense_tracker_app/features/auth/domain/repositories/auth_repository.dart';

class LoginWithEmailPassword extends UseCase<Either, LoginParams> {
  final AuthRepository authRepository;

  LoginWithEmailPassword(this.authRepository);

  @override
  Future<Either> call({LoginParams? params}) async {
    final response = await authRepository.loginWithEmailPassword(
      email: params!.email,
      password: params.password,
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

class LoginParams {
  final String email;
  final String password;

  LoginParams({
    required this.email,
    required this.password,
  });
}
