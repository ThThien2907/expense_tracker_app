import 'package:expense_tracker_app/core/assets/app_vectors.dart';
import 'package:expense_tracker_app/core/common/constant/app_const.dart';
import 'package:expense_tracker_app/core/common/extensions/currency_formatter.dart';
import 'package:expense_tracker_app/core/common/extensions/get_localized_name.dart';
import 'package:expense_tracker_app/core/common/widgets/app_bar/custom_app_bar.dart';
import 'package:expense_tracker_app/core/common/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:expense_tracker_app/core/common/widgets/button/app_button.dart';
import 'package:expense_tracker_app/core/common/widgets/loading/loading.dart';
import 'package:expense_tracker_app/core/common/widgets/snack_bar/app_snack_bar.dart';
import 'package:expense_tracker_app/core/common/widgets/text_field/app_text_field.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:expense_tracker_app/features/setting/domain/entities/setting_entity.dart';
import 'package:expense_tracker_app/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:expense_tracker_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker_app/features/wallet/domain/entities/wallet_entity.dart';
import 'package:expense_tracker_app/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AddOrEditWallet extends StatefulWidget {
  const AddOrEditWallet({
    super.key,
    required this.isEdit,
    this.wallet,
  });

  final bool isEdit;
  final WalletEntity? wallet;

  @override
  State<AddOrEditWallet> createState() => _AddOrEditWalletState();
}

class _AddOrEditWalletState extends State<AddOrEditWallet> {
  final TextEditingController balanceController =
      TextEditingController(text: '0');
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  late SettingEntity settingEntity;

  @override
  void initState() {
    super.initState();
    settingEntity = context.read<SettingBloc>().state.setting;
    if (widget.isEdit) {
      if (widget.wallet != null) {
        balanceController.text = CurrencyFormatter.format(
          amount: widget.wallet!.balance,
          toCurrency: settingEntity.currency,
          isShowSymbol: false,
        );
        nameController.text = widget.wallet!.name.toString();
        typeController.text = widget.wallet!.type.toString();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    balanceController.dispose();
    nameController.dispose();
    typeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state.status == WalletStatus.loading) {
          Loading.show(context);
        } else {
          Loading.hide(context);
        }
        if (state.status == WalletStatus.failure) {
          AppSnackBar.showError(
            context,
            GetLocalizedName.getLocalizedName(
              context,
              state.errorMessage,
            ),
          );
        }
        if (state.status == WalletStatus.success) {
          context.pop('Success');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.violet100,
        appBar: CustomAppBar(
          title: widget.isEdit
              ? AppLocalizations.of(context)!.editWallet
              : AppLocalizations.of(context)!.addNewWallet,
          centerTitle: true,
          titleColor: AppColors.light100,
          foregroundColor: AppColors.light100,
          backgroundColor: AppColors.violet100,
          action: widget.isEdit
              ? [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: IconButton(
                      onPressed: () {
                        AppBottomSheet.show(
                          context: context,
                          widget: ConfirmEventBottomSheet(
                            title:
                                AppLocalizations.of(context)!.removeThisWallet,
                            subtitle: AppLocalizations.of(context)!
                                .confirmRemoveWallet,
                            onPressedYesButton: () {
                              context.pop();
                              context.read<WalletBloc>().add(
                                    WalletRemoved(
                                      walletId: widget.wallet!.walletId,
                                      budgetBloc: context.read<BudgetBloc>(),
                                      transactionBloc:
                                          context.read<TransactionBloc>(),
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
                ]
              : [],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      AppLocalizations.of(context)!.balance,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        color: AppColors.light80.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildWalletBalanceField(context),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 28,
                    ),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(32),
                          topLeft: Radius.circular(32),
                        ),
                        color: AppColors.light100),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        AppTextField(
                          controller: nameController,
                          hintText: AppLocalizations.of(context)!.name,
                          maxLength: 30,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        _buildWalletTypeField(context),
                        const SizedBox(
                          height: 32,
                        ),
                        AppButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (balanceController.text.isNotEmpty &&
                                nameController.text.isNotEmpty &&
                                typeController.text.isNotEmpty) {
                              double balance = CurrencyFormatter.unFormat(
                                amount: balanceController.text.trim(),
                                fromCurrency: settingEntity.currency,
                              );
                              int type = int.parse(typeController.text.trim());
                              if (widget.isEdit) {
                                context.read<WalletBloc>().add(
                                      WalletEdited(
                                        walletId: widget.wallet!.walletId,
                                        name: nameController.text.trim(),
                                        balance: balance,
                                        type: type,
                                        transactionBloc:
                                            context.read<TransactionBloc>(),
                                        budgetBloc: context.read<BudgetBloc>(),
                                      ),
                                    );
                              } else {
                                context.read<WalletBloc>().add(
                                      WalletAdded(
                                        name: nameController.text.trim(),
                                        balance: balance,
                                        type: type,
                                        transactionBloc:
                                            context.read<TransactionBloc>(),
                                      ),
                                    );
                              }
                            } else {
                              AppSnackBar.showError(
                                  context, AppLocalizations.of(context)!.fillIn);
                            }
                          },
                          buttonText: AppLocalizations.of(context)!.apply,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWalletBalanceField(BuildContext context) {
    return TextField(
      controller: balanceController,
      inputFormatters: [CurrencyInputFormatter(allowMinus: true)],
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        prefixIcon: Text(
          AppConst.currencies
              .firstWhere(
                  (currency) => currency.currencyCode == settingEntity.currency)
              .currencySymbol,
          style: const TextStyle(
            fontFamily: 'Inter',
            color: AppColors.light80,
            fontSize: 42,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      style: const TextStyle(
        fontFamily: 'Inter',
        color: AppColors.light80,
        fontSize: 42,
        fontWeight: FontWeight.w700,
      ),
      cursorColor: AppColors.light80,
      cursorWidth: 3,
      cursorHeight: 42,
    );
  }

  Widget _buildWalletTypeField(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.walletType,
        hintStyle: const TextStyle(
          fontFamily: 'Inter',
          color: AppColors.light20,
          fontSize: 16,
        ),
      ),
      style: const TextStyle(
        fontFamily: 'Inter',
        color: AppColors.dark100,
        fontSize: 16,
      ),
      value: widget.isEdit ? int.parse(typeController.text.trim()) : null,
      items: [
        DropdownMenuItem(
          value: 0,
          child: Text(AppLocalizations.of(context)!.wallet),
        ),
        DropdownMenuItem(
          value: 1,
          child: Text(AppLocalizations.of(context)!.bank),
        ),
      ],
      onChanged: (value) {
        typeController.text = value.toString();
      },
    );
  }
}
