import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/usecase/usecase.dart';
import 'package:expense_tracker_app/features/auth/domain/repositories/auth_repository.dart';

class SignUpWithEmailPassword extends UseCase<Either, SignUpParams> {
  final AuthRepository authRepository;

  SignUpWithEmailPassword(this.authRepository);

  @override
  Future<Either> call({SignUpParams? params}) async {
    final response = await authRepository.signUpWithEmailPassword(
      fullName: params!.fullName,
      email: params.email,
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

class SignUpParams {
  final String fullName;
  final String email;
  final String password;

  SignUpParams({
    required this.fullName,
    required this.email,
    required this.password,
  });
}
