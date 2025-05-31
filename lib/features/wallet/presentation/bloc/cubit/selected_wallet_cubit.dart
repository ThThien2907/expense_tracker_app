import 'package:expense_tracker_app/features/wallet/domain/entities/wallet_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedWalletCubit extends Cubit<WalletEntity?>{
  SelectedWalletCubit() : super(null);

  setWallet(WalletEntity wallet) => emit(wallet);
}