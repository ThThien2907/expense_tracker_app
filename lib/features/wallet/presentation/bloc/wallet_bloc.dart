import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker_app/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:expense_tracker_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker_app/features/wallet/data/models/wallet_model.dart';
import 'package:expense_tracker_app/features/wallet/domain/entities/wallet_entity.dart';
import 'package:expense_tracker_app/features/wallet/domain/use_cases/add_new_wallet.dart';
import 'package:expense_tracker_app/features/wallet/domain/use_cases/delete_wallet.dart';
import 'package:expense_tracker_app/features/wallet/domain/use_cases/edit_wallet.dart';
import 'package:expense_tracker_app/features/wallet/domain/use_cases/load_wallets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'wallet_event.dart';

part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final LoadWallets _loadWallets;
  final AddNewWallet _addNewWallet;
  final EditWallet _editWallet;
  final DeleteWallet _deleteWallet;

  WalletBloc({
    required LoadWallets loadWallets,
    required AddNewWallet addNewWallet,
    required EditWallet editWallet,
    required DeleteWallet deleteWallet,
  })  : _loadWallets = loadWallets,
        _addNewWallet = addNewWallet,
        _editWallet = editWallet,
        _deleteWallet = deleteWallet,
        super(const WalletState()) {
    on<WalletStarted>(_onWalletStarted);
    on<WalletAdded>(_onWalletAdded);
    on<WalletEdited>(_onWalletEdited);
    on<WalletRemoved>(_onWalletRemoved);
    on<WalletChanged>(_onWalletChanged);
    on<ClearWallets>(_onClearWallets);
  }

  _onWalletStarted(
    WalletStarted event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(status: WalletStatus.loading));
    final response = await _loadWallets.call();
    response.fold(
      (ifLeft) {
        emit(
          state.copyWith(
            status: WalletStatus.failure,
            errorMessage: ifLeft,
          ),
        );
        event.completer?.completeError(ifLeft);
      },
      (ifRight) {
        final wallets = ifRight as List<WalletEntity>;
        double totalBalance = 0;
        for (var wallet in wallets) {
          totalBalance += wallet.balance;
        }
        WalletModel totalWallet = WalletModel(
          walletId: 'total',
          name: 'Total',
          balance: totalBalance,
          userId: '',
          type: 0,
          createdAt: DateTime.now(),
        );
        wallets.add(totalWallet);
        wallets.sort((a, b) => b.balance.compareTo(a.balance));
        emit(
          state.copyWith(
            status: WalletStatus.success,
            wallets: wallets,
          ),
        );
        event.completer?.complete();
      },
    );
  }

  _onWalletAdded(
    WalletAdded event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(status: WalletStatus.loading));

    final response = await _addNewWallet.call(
      params: AddNewWalletParams(
        name: event.name,
        balance: event.balance,
        type: event.type,
      ),
    );

    response.fold(
      (ifLeft) => emit(state.copyWith(
        status: WalletStatus.failure,
        errorMessage: ifLeft,
      )),
      (ifRight) {
        final data = ifRight as Map<String, dynamic>;
        final newWallet = WalletModel.fromMap(data['wallet']);
        _updateTotalWallet(event: event, newWallet: newWallet);
        state.wallets.add(newWallet);
        state.wallets.sort((a, b) => b.balance.compareTo(a.balance));

        if (data['transaction'] != null) {
          event.transactionBloc.add(
            TransactionAddedByWallet(
              data: data['transaction'],
            ),
          );
        }

        emit(state.copyWith(
          status: WalletStatus.success,
        ));
      },
    );
  }

  _onWalletEdited(
    WalletEdited event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(status: WalletStatus.loading));

    final response = await _editWallet.call(
      params: EditWalletParams(
        walletId: event.walletId,
        name: event.name,
        balance: event.balance,
        type: event.type,
      ),
    );

    if (response.isLeft()) {
      final error = response.fold((ifLeft) => ifLeft, (ifRight) => null);
      emit(state.copyWith(
        status: WalletStatus.failure,
        errorMessage: error,
      ));
    } else {
      final data = response.fold((ifLeft) => null, (ifRight) => ifRight)
          as Map<String, dynamic>;

      final newWallet = WalletModel.fromMap(data['wallet']);
      final oldWallet = state.wallets.firstWhere(
        (wallet) => wallet.walletId == event.walletId,
      );
      _updateTotalWallet(
        event: event,
        oldWallet: oldWallet,
        newWallet: newWallet,
      );
      state.wallets.remove(oldWallet);
      state.wallets.add(newWallet);
      state.wallets.sort((a, b) => b.balance.compareTo(a.balance));

      if (data['transaction'] != null) {
        event.transactionBloc.add(
          TransactionAddedByWallet(
            data: data['transaction'],
          ),
        );
      }

      final completer = Completer<void>();
      event.budgetBloc.add(BudgetStarted(completer: completer));
      await completer.future;

      emit(state.copyWith(
        status: WalletStatus.success,
      ));
    }
  }

  _onWalletRemoved(
    WalletRemoved event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(status: WalletStatus.loading));

    final response = await _deleteWallet.call(
      params: event.walletId,
    );

    if (response.isRight()) {
      final oldWallet = state.wallets
          .firstWhere((wallet) => wallet.walletId == event.walletId);

      _updateTotalWallet(event: event, oldWallet: oldWallet);
      state.wallets.remove(oldWallet);

      final budgetCompleter = Completer<void>();
      event.budgetBloc.add(BudgetStarted(completer: budgetCompleter));

      final transactionCompleter = Completer<void>();
      event.transactionBloc.add(TransactionStarted(
        completer: transactionCompleter,
      ));

      await budgetCompleter.future;
      await transactionCompleter.future;

      emit(state.copyWith(
        status: WalletStatus.success,
      ));
    }
  }

  _onWalletChanged(
    WalletChanged event,
    Emitter<WalletState> emit,
  ) {
    emit(state.copyWith(
      status: WalletStatus.loading,
    ));

    final newWallet = WalletModel.fromMap(event.data);
    final oldWallet =
        state.wallets.firstWhere((e) => e.walletId == newWallet.walletId);

    _updateTotalWallet(
      event: event,
      newWallet: newWallet,
      oldWallet: oldWallet,
    );

    oldWallet.balance = newWallet.balance;

    emit(state.copyWith(
      status: WalletStatus.success,
    ));
  }

  _onClearWallets(
    ClearWallets event,
    Emitter<WalletState> emit,
  ) {
    emit(state.copyWith(
      status: WalletStatus.initial,
      wallets: const [],
      errorMessage: '',
    ));
  }

  _updateTotalWallet({
    required WalletEvent event,
    WalletEntity? oldWallet,
    WalletEntity? newWallet,
  }) {
    WalletEntity totalWallet = state.wallets.firstWhere(
      (wallet) => wallet.walletId == 'total',
    );
    if (event is WalletAdded) {
      totalWallet.balance += newWallet!.balance;
    }
    if (event is WalletEdited || event is WalletChanged) {
      double rangeBalance = newWallet!.balance - oldWallet!.balance;
      totalWallet.balance += rangeBalance;
    }
    if (event is WalletRemoved) {
      totalWallet.balance -= oldWallet!.balance;
    }
  }
}
