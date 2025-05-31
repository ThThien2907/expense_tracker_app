import 'package:expense_tracker_app/core/common/extensions/currency_formatter.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:expense_tracker_app/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TotalBalance extends StatelessWidget {
  const TotalBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.totalBalance,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: AppColors.light20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          BlocBuilder<SettingBloc, SettingState>(
            builder: (context, settingState) {
              return BlocBuilder<WalletBloc, WalletState>(
                builder: (context, walletState) {
                  return Text(
                    CurrencyFormatter.format(
                      amount: walletState.wallets
                          .firstWhere((wallet) => wallet.walletId == 'total')
                          .balance,
                      toCurrency: settingState.setting.currency,
                    ),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 32,
                      color: AppColors.dark75,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
