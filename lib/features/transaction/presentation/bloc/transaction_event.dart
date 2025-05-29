part of 'transaction_bloc.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();
}

final class TransactionStarted extends TransactionEvent {
  final Completer<void>? completer;

  const TransactionStarted({
    this.completer,
  });

  @override
  List<Object?> get props => [completer];
}

final class TransactionAdded extends TransactionEvent {
  final String categoryId;
  final String walletId;
  final double amount;
  final String description;
  final DateTime createdAt;
  final WalletBloc walletBloc;
  final BudgetBloc budgetBloc;

  const TransactionAdded({
    required this.categoryId,
    required this.walletId,
    required this.amount,
    required this.description,
    required this.createdAt,
    required this.walletBloc,
    required this.budgetBloc,
  });

  @override
  List<Object?> get props => [
        categoryId,
        walletId,
        amount,
        description,
        createdAt,
        walletBloc,
        budgetBloc,
      ];
}

final class TransactionEdited extends TransactionEvent {
  final String transactionId;
  final String categoryId;
  final String walletId;
  final double amount;
  final String description;
  final DateTime createdAt;
  final WalletBloc walletBloc;
  final BudgetBloc budgetBloc;

  const TransactionEdited({
    required this.transactionId,
    required this.categoryId,
    required this.walletId,
    required this.amount,
    required this.description,
    required this.createdAt,
    required this.walletBloc,
    required this.budgetBloc,
  });

  @override
  List<Object?> get props => [
        transactionId,
        categoryId,
        walletId,
        amount,
        description,
        createdAt,
        walletBloc,
        budgetBloc,
      ];
}

final class TransactionRemoved extends TransactionEvent {
  final String transactionId;
  final WalletBloc walletBloc;
  final BudgetBloc budgetBloc;

  const TransactionRemoved({
    required this.transactionId,
    required this.walletBloc,
    required this.budgetBloc,
  });

  @override
  List<Object?> get props => [transactionId, walletBloc, budgetBloc];
}

final class ClearTransactions extends TransactionEvent {
  @override
  List<Object?> get props => [];
}

final class TransactionAddedByWallet extends TransactionEvent {
  final Map<String, dynamic> data;

  const TransactionAddedByWallet({required this.data});

  @override
  List<Object?> get props => [];
}
