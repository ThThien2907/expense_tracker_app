import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/usecase/usecase.dart';
import 'package:expense_tracker_app/features/transaction/domain/repositories/transaction_repository.dart';

class EditTransaction extends UseCase<Either, EditTransactionParams> {
  final TransactionRepository transactionRepository;

  EditTransaction(this.transactionRepository);

  @override
  Future<Either> call({EditTransactionParams? params}) async {
    final response = await transactionRepository.editTransactions(
      transactionId: params!.transactionId,
      categoryId: params.categoryId,
      walletId: params.walletId,
      amount: params.amount,
      description: params.description,
      createdAt: params.createdAt,
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

class EditTransactionParams {
  final String transactionId;
  final String categoryId;
  final String walletId;
  final double amount;
  final String description;
  final DateTime createdAt;

  EditTransactionParams({
    required this.transactionId,
    required this.categoryId,
    required this.walletId,
    required this.amount,
    required this.description,
    required this.createdAt,
  });
}
