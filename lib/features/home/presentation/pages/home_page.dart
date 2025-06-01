import 'package:expense_tracker_app/core/common/cubits/type/selected_type_cubit.dart';
import 'package:expense_tracker_app/core/common/extensions/currency_formatter.dart';
import 'package:expense_tracker_app/core/common/extensions/generate_chart_data.dart';
import 'package:expense_tracker_app/core/common/widgets/app_bar/custom_app_bar.dart';
import 'package:expense_tracker_app/core/common/widgets/button/app_button.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/navigation/app_router.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/report/presentation/widgets/line_chart_report.dart';
import 'package:expense_tracker_app/features/setting/domain/entities/setting_entity.dart';
import 'package:expense_tracker_app/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:expense_tracker_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker_app/features/transaction/presentation/widgets/transaction_item.dart';
import 'package:expense_tracker_app/features/wallet/domain/entities/wallet_entity.dart';
import 'package:expense_tracker_app/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:expense_tracker_app/features/wallet/presentation/widgets/wallet_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        widget: SizedBox(
          height: 60,
          child: Column(
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
              const Spacer(),
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
                      final totalWallet =
                          walletState.wallets.firstWhere((wallet) => wallet.walletId == 'total');
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
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 48,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.myWallet,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    color: AppColors.dark25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                _buildSeeMoreButton(
                  context: context,
                  label: AppLocalizations.of(context)!.seeAll,
                  onTap: () {
                    context.push(RoutePaths.wallet);
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            const Divider(
              color: AppColors.light40,
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  List<WalletEntity> wallets = [...state.wallets];
                  wallets.removeWhere((wallet) => wallet.walletId == 'total');

                  if (wallets.isEmpty && state.status == WalletStatus.success) {
                    return Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.doNotHaveWallet,
                          style: const TextStyle(
                            color: AppColors.light20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        AppButton(
                          onPressed: () {
                            context.push(
                              RoutePaths.wallet + RoutePaths.addOrEditWallet,
                              extra: ({
                                'isEdit': false,
                              }),
                            );
                          },
                          buttonText: AppLocalizations.of(context)!.addNewWallet,
                          width: double.minPositive,
                        )
                      ],
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: wallets.length,
                    itemBuilder: (context, index) {
                      return WalletItem(wallet: wallets[index]);
                    },
                  );
                },
              ),
            ),
            const Divider(
              color: AppColors.light40,
              thickness: 2,
            ),
            const SizedBox(
              height: 48,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.reportThisMonth,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    color: AppColors.dark25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                _buildSeeMoreButton(
                  context: context,
                  label: AppLocalizations.of(context)!.seeReport,
                  onTap: () {
                    context.push(RoutePaths.report);
                  },
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            BlocProvider(
              create: (context) => SelectedTypeCubit(),
              child: BlocBuilder<SettingBloc, SettingState>(
                builder: (context, settingState) {
                  return BlocBuilder<TransactionBloc, TransactionState>(
                    builder: (context, state) {
                      final now = DateTime.now();
                      final transactionsByMonth = state.transactions
                          .where((e) =>
                              e.createdAt.isAfter(DateTime(now.year, now.month, 1)) &&
                              e.createdAt.isBefore(DateTime(now.year, now.month + 1, 1)))
                          .toList();
                      final lineChartData = GenerateChartData.generateLineChartData(
                        transactions: transactionsByMonth,
                        currency: settingState.setting.currency,
                        month: now,
                      );
                      return BlocBuilder<SelectedTypeCubit, int>(
                        builder: (context, type) {
                          final isExpense = type == 0;
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTotalAmountButton(
                                      context: context,
                                      setting: settingState.setting,
                                      backgroundColor:
                                          isExpense ? AppColors.red100 : AppColors.light60,
                                      label: AppLocalizations.of(context)!.totalExpense,
                                      labelColor: isExpense ? AppColors.light80 : AppColors.dark75,
                                      currency: lineChartData['expense']['totalAmount'],
                                      currencyColor:
                                          isExpense ? AppColors.light80 : AppColors.red100,
                                      onTap: () {
                                        context.read<SelectedTypeCubit>().setType(0);
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 24,
                                  ),
                                  Expanded(
                                    child: _buildTotalAmountButton(
                                      context: context,
                                      setting: settingState.setting,
                                      backgroundColor:
                                          isExpense ? AppColors.light60 : AppColors.green100,
                                      label: AppLocalizations.of(context)!.totalIncome,
                                      labelColor: isExpense ? AppColors.dark75 : AppColors.light80,
                                      currency: lineChartData['income']['totalAmount'],
                                      currencyColor:
                                          isExpense ? AppColors.green100 : AppColors.light80,
                                      onTap: () {
                                        context.read<SelectedTypeCubit>().setType(1);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              LineChartReport(
                                chartData:
                                    type == 0 ? lineChartData['expense'] : lineChartData['income'],
                                isExpense: type == 0,
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: 48,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.recentTransaction,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    color: AppColors.dark25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                _buildSeeMoreButton(
                  context: context,
                  label: AppLocalizations.of(context)!.seeAll,
                  onTap: () {
                    context.go(RoutePaths.transaction);
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state.transactions.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 32, bottom: 120),
                    child: Text(
                      AppLocalizations.of(context)!.doNotHaveRecentTransactions,
                      style: const TextStyle(
                        color: AppColors.light20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 120),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return TransactionItem(
                      transactionEntity: state.transactions[index],
                      isShowCreatedAt: true,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: state.transactions.length < 4 ? state.transactions.length : 4,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalAmountButton({
    required BuildContext context,
    required Color backgroundColor,
    required String label,
    required Color labelColor,
    required double currency,
    required Color currencyColor,
    required SettingEntity setting,
    required VoidCallback onTap,
  }) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: labelColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                CurrencyFormatter.format(
                  amount: currency,
                  toCurrency: setting.currency,
                  fromCurrency: setting.currency,
                ),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  color: currencyColor,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeeMoreButton({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.violet20,
      borderRadius: BorderRadius.circular(40),
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 32,
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.violet100,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
