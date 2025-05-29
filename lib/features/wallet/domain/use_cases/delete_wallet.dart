import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/usecase/usecase.dart';
import 'package:expense_tracker_app/features/wallet/domain/repositories/wallet_repository.dart';

class DeleteWallet extends UseCase<Either, String> {
  final WalletRepository walletRepository;

  DeleteWallet(this.walletRepository);

  @override
  Future<Either> call({String? params}) async {
    final response = await walletRepository.deleteWallet(
      walletId: params!,
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

