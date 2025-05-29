import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/usecase/usecase.dart';
import 'package:expense_tracker_app/features/wallet/domain/repositories/wallet_repository.dart';

class LoadWallets extends UseCase<Either, NoParams>{
  final WalletRepository walletRepository;

  LoadWallets(this.walletRepository);

  @override
  Future<Either> call({NoParams? params}) async {
    final response = await walletRepository.loadWallets();
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