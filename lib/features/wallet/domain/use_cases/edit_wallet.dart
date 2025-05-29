import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/usecase/usecase.dart';
import 'package:expense_tracker_app/features/wallet/domain/repositories/wallet_repository.dart';

class EditWallet extends UseCase<Either, EditWalletParams> {
  final WalletRepository walletRepository;

  EditWallet(this.walletRepository);

  @override
  Future<Either> call({EditWalletParams? params}) async {
    final response = await walletRepository.editWallet(
      walletId: params!.walletId,
      name: params.name,
      balance: params.balance,
      type: params.type,
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

class EditWalletParams {
  final String walletId;
  final String name;
  final double balance;
  final int type;

  EditWalletParams({
    required this.walletId,
    required this.name,
    required this.balance,
    required this.type,
  });
}
