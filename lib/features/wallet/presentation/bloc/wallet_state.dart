part of 'wallet_bloc.dart';

enum WalletStatus { initial, loading, success, failure }

final class WalletState extends Equatable {
  final WalletStatus status;
  final List<WalletEntity> wallets;
  final String errorMessage;

  const WalletState({
    this.status = WalletStatus.initial,
    this.wallets = const [],
    this.errorMessage = '',
  });

  WalletState copyWith({
    WalletStatus? status,
    List<WalletEntity>? wallets,
    String? errorMessage,
  }) {
    return WalletState(
      status: status ?? this.status,
      wallets: wallets ?? this.wallets,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, wallets, errorMessage];
}