import 'package:expense_tracker_app/core/assets/app_vectors.dart';
import 'package:expense_tracker_app/core/common/extensions/currency_formatter.dart';
import 'package:expense_tracker_app/core/common/extensions/date_formatter.dart';
import 'package:expense_tracker_app/core/common/extensions/get_localized_name.dart';
import 'package:expense_tracker_app/core/common/widgets/app_bar/custom_app_bar.dart';
import 'package:expense_tracker_app/core/common/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:expense_tracker_app/core/common/widgets/button/app_button.dart';
import 'package:expense_tracker_app/core/common/widgets/loading/loading.dart';
import 'package:expense_tracker_app/core/common/widgets/snack_bar/app_snack_bar.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/navigation/app_router.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:expense_tracker_app/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:expense_tracker_app/features/transaction/domain/entities/transaction_entity.dart';
import 'package:expense_tracker_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker_app/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class DetailTransactionPage extends StatelessWidget {
  const DetailTransactionPage({
    super.key,
    required this.transactionEntity,
  });

  final TransactionEntity transactionEntity;

  @override
  Widget build(BuildContext context) {
    bool isExpense = transactionEntity.category.type == 0;
    final wallet = context.read<WalletBloc>().state.wallets.firstWhere(
          (e) => e.walletId == transactionEntity.walletId,
        );

    return Scaffold(
      backgroundColor: isExpense ? AppColors.red100 : AppColors.green100,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.detailTransaction,
        centerTitle: true,
        titleColor: AppColors.light100,
        foregroundColor: AppColors.light100,
        backgroundColor: isExpense ? AppColors.red100 : AppColors.green100,
        action: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                AppBottomSheet.show(
                  context: context,
                  widget: ConfirmEventBottomSheet(
                    title: AppLocalizations.of(context)!.removeThisTransaction,
                    subtitle:
                        AppLocalizations.of(context)!.confirmRemoveTransaction,
                    onPressedYesButton: () {
                      context.pop();
                      context.read<TransactionBloc>().add(
                            TransactionRemoved(
                              transactionId: transactionEntity.transactionId,
                              walletBloc: context.read<WalletBloc>(),
                              budgetBloc: context.read<BudgetBloc>(),
                            ),
                          );
                    },
                  ),
                );
              },
              icon: SvgPicture.asset(
                AppVectors.deleteIcon,
                colorFilter: const ColorFilter.mode(
                  AppColors.light100,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state.status == TransactionStatus.loading) {
            Loading.show(context);
          } else {
            Loading.hide(context);
          }

          if (state.status == TransactionStatus.failure) {
            AppSnackBar.showError(
              context,
              GetLocalizedName.getLocalizedName(
                context,
                state.errorMessage,
              ),
            );
          }

          if (state.status == TransactionStatus.success) {
            context.pop();
          }
        },
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            BlocBuilder<SettingBloc, SettingState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    CurrencyFormatter.format(
                      amount: transactionEntity.amount,
                      toCurrency: state.setting.currency,
                    ),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      color: AppColors.light80,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              DateFormatter.formatDateLabel(
                  context, transactionEntity.createdAt),
              style: const TextStyle(
                fontFamily: 'Inter',
                color: AppColors.light60,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 36,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: AppColors.light100,
                child: Column(
                  children: [
                    SizedBox(
                      height: 90,
                      child: Stack(
                        children: [
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: isExpense
                                  ? AppColors.red100
                                  : AppColors.green100,
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(16),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              height: 90,
                              decoration: BoxDecoration(
                                color: AppColors.light100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.light60,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  _buildLabelContent(
                                    context,
                                    AppLocalizations.of(context)!.type,
                                    isExpense
                                        ? AppLocalizations.of(context)!.expense
                                        : AppLocalizations.of(context)!.income,
                                  ),
                                  _buildLabelContent(
                                    context,
                                    AppLocalizations.of(context)!.category,
                                    GetLocalizedName.getLocalizedName(
                                      context,
                                      transactionEntity.category.name,
                                    ),
                                  ),
                                  _buildLabelContent(
                                    context,
                                    AppLocalizations.of(context)!.wallet,
                                    wallet.name,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.description,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              color: AppColors.light20,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              transactionEntity.description,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                color: AppColors.dark100,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AppButton(
                        onPressed: () {
                          context.push(
                            RoutePaths.addOrEditTransaction,
                            extra: ({
                              'isEdit': true,
                              'isExpense': transactionEntity.category.type == 0,
                              'transaction': transactionEntity,
                            }),
                          );
                        },
                        buttonText:
                            AppLocalizations.of(context)!.editTransaction,
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelContent(
    BuildContext context,
    String label,
    String content,
  ) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              color: AppColors.light20,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            content,
            style: const TextStyle(
              fontFamily: 'Inter',
              color: AppColors.dark100,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
