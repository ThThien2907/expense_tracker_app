import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/usecase/usecase.dart';
import 'package:expense_tracker_app/features/transaction/domain/repositories/transaction_repository.dart';

class LoadTransactions extends UseCase<Either, NoParams> {
  final TransactionRepository transactionRepository;

  LoadTransactions(this.transactionRepository);

  @override
  Future<Either> call({NoParams? params}) async {
    final response = await transactionRepository.loadTransactions();

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
