import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/usecase/usecase.dart';
import 'package:expense_tracker_app/features/transaction/domain/repositories/transaction_repository.dart';

class AddNewTransaction extends UseCase<Either, AddNewTransactionParams> {
  final TransactionRepository transactionRepository;

  AddNewTransaction(this.transactionRepository);

  @override
  Future<Either> call({AddNewTransactionParams? params}) async {
    final response = await transactionRepository.addNewTransactions(
      categoryId: params!.categoryId,
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

class AddNewTransactionParams {
  final String categoryId;
  final String walletId;
  final double amount;
  final String description;
  final DateTime createdAt;

  AddNewTransactionParams({
    required this.categoryId,
    required this.walletId,
    required this.amount,
    required this.description,
    required this.createdAt,
  });
}
