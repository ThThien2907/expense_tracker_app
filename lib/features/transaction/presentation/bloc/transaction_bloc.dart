import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:expense_tracker_app/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:expense_tracker_app/features/transaction/domain/entities/transaction_entity.dart';
import 'package:expense_tracker_app/features/transaction/domain/use_cases/add_new_transaction.dart';
import 'package:expense_tracker_app/features/transaction/domain/use_cases/delete_transaction.dart';
import 'package:expense_tracker_app/features/transaction/domain/use_cases/edit_transaction.dart';
import 'package:expense_tracker_app/features/transaction/domain/use_cases/load_transactions.dart';
import 'package:expense_tracker_app/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'transaction_event.dart';

part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final LoadTransactions _loadTransactions;
  final AddNewTransaction _addNewTransaction;
  final EditTransaction _editTransaction;
  final DeleteTransaction _deleteTransaction;

  TransactionBloc({
    required LoadTransactions loadTransactions,
    required AddNewTransaction addNewTransaction,
    required EditTransaction editTransaction,
    required DeleteTransaction deleteTransaction,
  })  : _loadTransactions = loadTransactions,
        _addNewTransaction = addNewTransaction,
        _editTransaction = editTransaction,
        _deleteTransaction = deleteTransaction,
        super(const TransactionState()) {
    on<TransactionStarted>(_onTransactionStarted);
    on<TransactionAdded>(_onTransactionAdded);
    on<TransactionEdited>(_onTransactionEdited);
    on<TransactionRemoved>(_onTransactionRemoved);
    on<ClearTransactions>(_onClearTransactions);
    on<TransactionAddedByWallet>(_onTransactionAddedByWallet);
  }

  _onTransactionStarted(
    TransactionStarted event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(
      status: TransactionStatus.loading,
    ));
    final transactionResponse = await _loadTransactions.call();

    transactionResponse.fold(
      (ifLeft) {
        emit(state.copyWith(
          status: TransactionStatus.failure,
          errorMessage: ifLeft,
        ));
        event.completer?.completeError(ifLeft);
      },
      (ifRight) {
        emit(state.copyWith(
          status: TransactionStatus.success,
          transactions: ifRight,
        ));
        event.completer?.complete();
      },
    );
  }

  _onClearTransactions(
    ClearTransactions event,
    Emitter<TransactionState> emit,
  ) {
    emit(state.copyWith(
      status: TransactionStatus.initial,
      transactions: const [],
      errorMessage: '',
    ));
  }

  _onTransactionAdded(
    TransactionAdded event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading));

    final response = await _addNewTransaction.call(
      params: AddNewTransactionParams(
        categoryId: event.categoryId,
        walletId: event.walletId,
        amount: event.amount,
        description: event.description,
        createdAt: event.createdAt,
      ),
    );

    response.fold(
      (ifLeft) {
        emit(state.copyWith(
          status: TransactionStatus.failure,
          errorMessage: ifLeft,
        ));
      },
      (ifRight) {
        final data = ifRight;
        final newTransaction = data['transaction'];

        state.transactions.insert(0, newTransaction);
        state.transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        event.walletBloc.add(WalletChanged(wallet: data['wallet']));
        if (data['budgets'] != null) {
          event.budgetBloc.add(BudgetChanged(budgets: data['budgets']));
        }
        emit(state.copyWith(
          status: TransactionStatus.success,
        ));
      },
    );
  }

  _onTransactionEdited(
    TransactionEdited event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading));

    final response = await _editTransaction.call(
      params: EditTransactionParams(
        transactionId: event.transactionId,
        categoryId: event.categoryId,
        walletId: event.walletId,
        amount: event.amount,
        description: event.description,
        createdAt: event.createdAt,
      ),
    );

    response.fold(
      (ifLeft) {
        emit(state.copyWith(
          status: TransactionStatus.failure,
          errorMessage: ifLeft,
        ));
      },
      (ifRight) {
        final data = ifRight;
        final newTransaction = data['transaction'];

        state.transactions.removeWhere(
              (e) => e.transactionId == newTransaction.transactionId,
        );
        state.transactions.insert(0, newTransaction);
        state.transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        event.walletBloc.add(WalletChanged(wallet: data['old_wallet']));
        event.walletBloc.add(WalletChanged(wallet: data['new_wallet']));

        if (data['old_budgets'] != null) {
          event.budgetBloc.add(BudgetChanged(budgets: data['old_budgets']));
        }
        if (data['new_budgets'] != null) {
          event.budgetBloc.add(BudgetChanged(budgets: data['new_budgets']));
        }

        emit(state.copyWith(
          status: TransactionStatus.success,
        ));
      },
    );
  }

  _onTransactionRemoved(
    TransactionRemoved event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading));

    final response = await _deleteTransaction.call(
      params: DeleteTransactionParams(
        transactionId: event.transactionId,
      ),
    );

    response.fold(
      (ifLeft) {
        emit(state.copyWith(
          status: TransactionStatus.failure,
          errorMessage: ifLeft,
        ));
      },
      (ifRight) {
        final data = ifRight;
        state.transactions.removeWhere(
          (e) => e.transactionId == event.transactionId,
        );
        event.walletBloc.add(WalletChanged(wallet: data['wallet']));
        if (data['budgets'] != null) {
          event.budgetBloc.add(BudgetChanged(budgets: data['budgets']));
        }
        emit(state.copyWith(
          status: TransactionStatus.success,
        ));
      },
    );
  }

  _onTransactionAddedByWallet(
    TransactionAddedByWallet event,
    Emitter<TransactionState> emit,
  ) {
    emit(state.copyWith(status: TransactionStatus.loading));

    final newTransaction = event.transaction;
    state.transactions.insert(0, newTransaction);

    emit(state.copyWith(status: TransactionStatus.success));
  }
}
