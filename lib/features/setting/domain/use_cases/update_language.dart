import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/usecase/usecase.dart';
import 'package:expense_tracker_app/features/setting/domain/repositories/setting_repository.dart';

class UpdateLanguage extends UseCase<Either, UpdateLanguageParams> {
  final SettingRepository settingRepository;

  UpdateLanguage(this.settingRepository);

  @override
  Future<Either> call({UpdateLanguageParams? params}) async {
    final response = await settingRepository.updateLanguage(
      language: params!.language,
      userId: params.userId,
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

class UpdateLanguageParams {
  final String language;
  final String userId;

  UpdateLanguageParams({
    required this.language,
    required this.userId,
  });
}
