import 'package:expense_tracker_app/core/common/extensions/currency_formatter.dart';
import 'package:expense_tracker_app/core/common/widgets/app_bar/custom_app_bar.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:expense_tracker_app/features/transaction/presentation/widgets/transaction_list_by_month.dart';
import 'package:expense_tracker_app/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {

  DateTime initialDate = DateTime.now();
  DateFormat dateFormat = DateFormat('MM/yyyy');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        widget: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.totalBalance,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppColors.light20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    BlocBuilder<SettingBloc, SettingState>(
                      builder: (context, settingState) {
                        return BlocBuilder<WalletBloc, WalletState>(
                          builder: (context, walletState) {
                            if (walletState.wallets.isEmpty) {
                              return Text(
                                CurrencyFormatter.format(
                                  amount: 0,
                                  toCurrency: settingState.setting.currency,
                                ),
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 26,
                                  color: AppColors.dark75,
                                  fontWeight: FontWeight.w700,
                                ),
                              );
                            }
                            final totalWallet = walletState.wallets
                                .firstWhere((wallet) => wallet.walletId == 'total');
                            return Text(
                              CurrencyFormatter.format(
                                amount: totalWallet.balance,
                                toCurrency: settingState.setting.currency,
                              ),
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 26,
                                color: AppColors.dark75,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    showMonthPicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate: DateTime(2024),
                      lastDate: DateTime.now(),
                    ).then((date) {
                      if (date != null && date != initialDate) {
                        setState(() {
                          initialDate = date;
                        });
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 14, right: 8),
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          width: 2,
                          color: AppColors.light60,
                        )),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dateFormat.format(initialDate),
                          style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.dark50),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down_sharp,
                          size: 24,
                          color: AppColors.violet100,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        color: AppColors.light100,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Material(
              color: AppColors.violet20,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.seeYourFinancialReport,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.violet100,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: AppColors.violet100,
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TransactionListByMonth(
              initialDate: initialDate,
              padding: const EdgeInsets.only(bottom: 90),
            ),
          ],
        ),
      ),
    );
  }
}
