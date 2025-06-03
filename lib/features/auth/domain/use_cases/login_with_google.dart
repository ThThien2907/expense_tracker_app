import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/usecase/usecase.dart';
import 'package:expense_tracker_app/features/auth/domain/repositories/auth_repository.dart';

class LoginWithGoogle extends UseCase<Either, LoginWithGoogleParams> {
  final AuthRepository authRepository;

  LoginWithGoogle(this.authRepository);

  @override
  Future<Either> call({LoginWithGoogleParams? params}) async {
    final response = await authRepository.loginWithGoogle(language: params!.language);
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

class LoginWithGoogleParams {
  final String language;

  LoginWithGoogleParams({required this.language});
}
