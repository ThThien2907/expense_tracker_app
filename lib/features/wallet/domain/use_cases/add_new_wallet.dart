import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/usecase/usecase.dart';
import 'package:expense_tracker_app/features/wallet/domain/repositories/wallet_repository.dart';

class AddNewWallet extends UseCase<Either, AddNewWalletParams> {
  final WalletRepository walletRepository;

  AddNewWallet(this.walletRepository);

  @override
  Future<Either> call({AddNewWalletParams? params}) async {
    final response = await walletRepository.addNewWallet(
      name: params!.name,
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

class AddNewWalletParams {
  final String name;
  final double balance;
  final int type;

  AddNewWalletParams({
    required this.name,
    required this.balance,
    required this.type,
  });
}
