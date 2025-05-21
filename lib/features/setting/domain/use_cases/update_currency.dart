import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/usecase/usecase.dart';
import 'package:expense_tracker_app/features/setting/domain/repositories/setting_repository.dart';

class UpdateCurrency extends UseCase<Either, UpdateCurrencyParams> {
  final SettingRepository settingRepository;

  UpdateCurrency(this.settingRepository);

  @override
  Future<Either> call({UpdateCurrencyParams? params}) async {
    final response = await settingRepository.updateCurrency(
      currency: params!.currency,
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

class UpdateCurrencyParams {
  final String currency;
  final String userId;

  UpdateCurrencyParams({
    required this.currency,
    required this.userId,
  });
}
