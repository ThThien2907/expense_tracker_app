import 'package:expense_tracker_app/core/common/constant/app_const.dart';
import 'package:expense_tracker_app/core/common/extensions/currency_formatter.dart';
import 'package:expense_tracker_app/core/common/extensions/date_formatter.dart';
import 'package:expense_tracker_app/core/common/extensions/get_localized_name.dart';
import 'package:expense_tracker_app/core/common/widgets/app_bar/custom_app_bar.dart';
import 'package:expense_tracker_app/core/common/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:expense_tracker_app/core/common/widgets/button/app_button.dart';
import 'package:expense_tracker_app/core/common/widgets/loading/loading.dart';
import 'package:expense_tracker_app/core/common/widgets/snack_bar/app_snack_bar.dart';
import 'package:expense_tracker_app/core/common/widgets/text_field/app_text_field.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/navigation/app_router.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:expense_tracker_app/features/category/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker_app/features/category/presentation/widgets/category_item.dart';
import 'package:expense_tracker_app/features/setting/domain/entities/setting_entity.dart';
import 'package:expense_tracker_app/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:expense_tracker_app/features/transaction/domain/entities/transaction_entity.dart';
import 'package:expense_tracker_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker_app/features/wallet/domain/entities/wallet_entity.dart';
import 'package:expense_tracker_app/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:expense_tracker_app/features/wallet/presentation/widgets/wallet_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddOrEditTransaction extends StatefulWidget {
  const AddOrEditTransaction({
    super.key,
    this.isEdit = false,
    this.isExpense = false,
    required this.transactionEntity,
  });

  final bool isEdit;
  final bool isExpense;
  final TransactionEntity? transactionEntity;

  @override
  State<AddOrEditTransaction> createState() => _AddOrEditTransactionState();
}

class _AddOrEditTransactionState extends State<AddOrEditTransaction> {
  final TextEditingController amountController = TextEditingController(text: '0');
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController walletController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String categoryId = '';
  String walletId = '';

  late DateTime createdAt;
  DateTime now = DateTime.now();

  late SettingEntity settingEntity;

  @override
  void initState() {
    super.initState();
    settingEntity = context.read<SettingBloc>().state.setting;

    if (widget.isEdit) {
      amountController.text = CurrencyFormatter.format(
        amount: widget.transactionEntity!.amount,
        toCurrency: settingEntity.currency,
        isShowSymbol: false,
      );
      walletController.text = context
          .read<WalletBloc>()
          .state
          .wallets
          .firstWhere((e) => e.walletId == widget.transactionEntity!.walletId)
          .name;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        categoryController.text = GetLocalizedName.getLocalizedName(
          context,
          widget.transactionEntity!.category.name,
        );
        dateController.text = DateFormatter.formatDateLabel(context, createdAt);
      });

      descriptionController.text = widget.transactionEntity!.description;

      categoryId = widget.transactionEntity!.category.categoryId;
      walletId = widget.transactionEntity!.walletId;
      createdAt = widget.transactionEntity!.createdAt;
    } else {
      createdAt = now;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        dateController.text = DateFormatter.formatDateLabel(context, createdAt);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    amountController.dispose();
    categoryController.dispose();
    walletController.dispose();
    descriptionController.dispose();
    dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state.status == TransactionStatus.loading) {
          Loading.show(context);
        }
        if (state.status == TransactionStatus.failure) {
          Loading.hide(context);
          AppSnackBar.showError(
              context, GetLocalizedName.getLocalizedName(context, state.errorMessage));
        }

        if (state.status == TransactionStatus.success) {
          Loading.hide(context);
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: widget.isExpense ? AppColors.red100 : AppColors.green100,
        appBar: CustomAppBar(
          title: widget.isExpense
              ? widget.isEdit
                  ? AppLocalizations.of(context)!.editExpense
                  : AppLocalizations.of(context)!.addNewExpense
              : widget.isEdit
                  ? AppLocalizations.of(context)!.editIncome
                  : AppLocalizations.of(context)!.addNewIncome,
          centerTitle: true,
          titleColor: AppColors.light100,
          foregroundColor: AppColors.light100,
          backgroundColor: widget.isExpense ? AppColors.red100 : AppColors.green100,
        ),
        body: SingleChildScrollView(
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
                    AppLocalizations.of(context)!.amount,
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
                  child: _buildTransactionAmountField(context),
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
                    color: AppColors.light100,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      _buildCategoryButtonField(context),
                      const SizedBox(
                        height: 16,
                      ),
                      _buildWalletButtonField(context),
                      const SizedBox(
                        height: 16,
                      ),
                      AppTextField(
                        controller: descriptionController,
                        hintText: AppLocalizations.of(context)!.description,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      _buildDateTimePickerField(context),
                      const SizedBox(
                        height: 32,
                      ),
                      AppButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          double amount = CurrencyFormatter.unFormat(
                            amount: amountController.text.trim(),
                            fromCurrency: settingEntity.currency,
                          );
                          if (amountController.text.isEmpty ||
                              categoryController.text.isEmpty ||
                              walletController.text.isEmpty ||
                              categoryId.isEmpty ||
                              walletId.isEmpty ||
                              dateController.text.isEmpty ||
                              amount <= 0) {
                            AppSnackBar.showError(context, AppLocalizations.of(context)!.fillIn);
                            return;
                          }
                          if (widget.isEdit) {
                            context.read<TransactionBloc>().add(
                                  TransactionEdited(
                                    transactionId: widget.transactionEntity!.transactionId,
                                    walletId: walletId,
                                    categoryId: categoryId,
                                    amount: amount,
                                    description: descriptionController.text.trim(),
                                    createdAt: createdAt,
                                    walletBloc: context.read<WalletBloc>(),
                                    budgetBloc: context.read<BudgetBloc>(),
                                  ),
                                );
                          } else {
                            context.read<TransactionBloc>().add(
                                  TransactionAdded(
                                    categoryId: categoryId,
                                    walletId: walletId,
                                    amount: amount,
                                    description: descriptionController.text.trim(),
                                    createdAt: createdAt,
                                    walletBloc: context.read<WalletBloc>(),
                                    budgetBloc: context.read<BudgetBloc>(),
                                  ),
                                );
                          }
                        },
                        buttonText: AppLocalizations.of(context)!.apply,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionAmountField(BuildContext context) {
    return TextField(
      controller: amountController,
      inputFormatters: [CurrencyInputFormatter()],
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        prefixIcon: Text(
          AppConst.currencies
              .firstWhere((currency) => currency.currencyCode == settingEntity.currency)
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

  Widget _buildCategoryButtonField(BuildContext context) {
    return TextField(
      controller: categoryController,
      readOnly: true,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.category,
        suffixIcon: const Icon(
          Icons.arrow_drop_down_sharp,
          color: AppColors.light20,
          size: 32,
        ),
      ),
      style: const TextStyle(
        fontFamily: 'Inter',
        color: AppColors.dark100,
        fontSize: 16,
      ),
      onTap: () {
        AppBottomSheet.show(
          context: context,
          height: MediaQuery.of(context).size.height * 0.85,
          padding: EdgeInsets.zero,
          widget: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              final defaultCategories = widget.isExpense
                  ? [...state.defaultCategoriesExpense]
                  : [...state.defaultCategoriesIncome];

              final userCategories = widget.isExpense
                  ? [...state.userCategoriesExpense]
                  : [...state.userCategoriesIncome];
              return Scaffold(
                appBar: CustomAppBar(
                  title: widget.isExpense
                      ? AppLocalizations.of(context)!.expense
                      : AppLocalizations.of(context)!.income,
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.myCategories,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: AppColors.dark75,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      userCategories.isEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 24),
                                  child: Text(
                                    AppLocalizations.of(context)!.youHaveNotCreatedAnyCategoriesYet,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: AppColors.light20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding:  EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return CategoryItem(
                                  categoryEntity: userCategories[index],
                                  onTap: () {
                                    categoryController.text = GetLocalizedName.getLocalizedName(
                                      context,
                                      userCategories[index].name,
                                    );
                                    categoryId = userCategories[index].categoryId;
                                    context.pop();
                                  },
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 16,
                                );
                              },
                              itemCount: userCategories.length,
                            ),
                      const SizedBox(height: 16,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AppButton(
                          onPressed: () {
                            context.push(RoutePaths.category + RoutePaths.addOrEditCategory, extra: ({
                              'isEdit': false,
                            }));
                          },
                          buttonText: AppLocalizations.of(context)!.addNewCategory,
                        ),
                      ),
                      const SizedBox(height: 16,),
                      Text(
                        AppLocalizations.of(context)!.defaultCategories,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: AppColors.dark75,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 16),
                        itemBuilder: (context, index) {
                          return CategoryItem(
                            categoryEntity: defaultCategories[index],
                            onTap: () {
                              categoryController.text = GetLocalizedName.getLocalizedName(
                                context,
                                defaultCategories[index].name,
                              );
                              categoryId = defaultCategories[index].categoryId;
                              context.pop();
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 16,
                          );
                        },
                        itemCount: defaultCategories.length,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildWalletButtonField(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        List<WalletEntity> wallets = [...state.wallets];
        wallets.removeWhere((wallet) => wallet.walletId == 'total');

        return TextField(
          controller: walletController,
          readOnly: true,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.wallet,
            suffixIcon: const Icon(
              Icons.arrow_drop_down_sharp,
              color: AppColors.light20,
              size: 32,
            ),
          ),
          style: const TextStyle(
            fontFamily: 'Inter',
            color: AppColors.dark100,
            fontSize: 16,
          ),
          onTap: () {
            AppBottomSheet.show(
              context: context,
              height: MediaQuery.of(context).size.height * 0.85,
              padding: const EdgeInsets.only(bottom: 16),
              widget: Scaffold(
                appBar: CustomAppBar(
                  title: AppLocalizations.of(context)!.wallet,
                  centerTitle: true,
                ),
                body: ListView.separated(
                  itemBuilder: (context, index) {
                    return WalletItem(
                      wallet: wallets[index],
                      onTap: () {
                        if (walletId != wallets[index].walletId) {
                          walletController.text = wallets[index].name;
                          walletId = wallets[index].walletId;
                        }
                        context.pop();
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 16,
                    );
                  },
                  itemCount: wallets.length,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDateTimePickerField(BuildContext context) {
    return TextField(
      controller: dateController,
      readOnly: true,
      style: const TextStyle(
        fontFamily: 'Inter',
        color: AppColors.dark100,
        fontSize: 16,
      ),
      decoration: const InputDecoration(
        suffixIcon: Icon(
          Icons.calendar_month,
          color: AppColors.light20,
          size: 32,
        ),
        hintText: 'dd/MM/yyyy',
      ),
      onTap: () async {
        await showDatePicker(
          context: context,
          firstDate: DateTime(2024),
          lastDate: DateTime.now(),
          initialDate: createdAt,
        ).then((date) {
          if (date != null && date != createdAt) {
            setState(() {
              createdAt = createdAt.copyWith(
                year: date.year,
                month: date.month,
                day: date.day,
              );
              dateController.text = DateFormatter.formatDateLabel(
                context,
                createdAt,
              );
            });
          }
        });
      },
    );
  }
}
