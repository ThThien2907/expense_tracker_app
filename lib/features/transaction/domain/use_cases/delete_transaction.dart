import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/usecase/usecase.dart';
import 'package:expense_tracker_app/features/transaction/domain/repositories/transaction_repository.dart';

class DeleteTransaction extends UseCase<Either, DeleteTransactionParams> {
  final TransactionRepository transactionRepository;

  DeleteTransaction(this.transactionRepository);

  @override
  Future<Either> call({DeleteTransactionParams? params}) async {
    final response = await transactionRepository.deleteTransactions(
      transactionId: params!.transactionId,
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

class DeleteTransactionParams {
  final String transactionId;

  DeleteTransactionParams({
    required this.transactionId,
  });
}
