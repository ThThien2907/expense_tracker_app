part of 'wallet_bloc.dart';

sealed class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

final class WalletStarted extends WalletEvent {
  final Completer<void>? completer;

  const WalletStarted({this.completer});

  @override
  List<Object?> get props => [completer];
}

final class WalletAdded extends WalletEvent {
  final String name;
  final double balance;
  final int type;
  final TransactionBloc transactionBloc;

  const WalletAdded({
    required this.name,
    required this.balance,
    required this.type,
    required this.transactionBloc,
  });

  @override
  List<Object?> get props => [name, balance, type, transactionBloc];
}

final class WalletEdited extends WalletEvent {
  final String walletId;
  final String name;
  final double balance;
  final int type;
  final TransactionBloc transactionBloc;
  final BudgetBloc budgetBloc;

  const WalletEdited({
    required this.walletId,
    required this.name,
    required this.balance,
    required this.type,
    required this.transactionBloc,
    required this.budgetBloc,
  });

  @override
  List<Object?> get props => [
        walletId,
        name,
        balance,
        type,
        transactionBloc,
        budgetBloc,
      ];
}

final class WalletRemoved extends WalletEvent {
  final String walletId;
  final BudgetBloc budgetBloc;
  final TransactionBloc transactionBloc;

  const WalletRemoved({
    required this.walletId,
    required this.budgetBloc,
    required this.transactionBloc,
  });

  @override
  List<Object?> get props => [walletId, budgetBloc, transactionBloc];
}

final class WalletChanged extends WalletEvent {
  final WalletEntity wallet;

  const WalletChanged({
    required this.wallet,
  });

  @override
  List<Object?> get props => [wallet];
}

final class ClearWallets extends WalletEvent {
  @override
  List<Object?> get props => [];
}
