import 'package:expense_tracker_app/core/common/constant/app_const.dart';
import 'package:expense_tracker_app/core/common/extensions/currency_formatter.dart';
import 'package:expense_tracker_app/core/common/extensions/get_localized_name.dart';
import 'package:expense_tracker_app/core/common/widgets/app_bar/custom_app_bar.dart';
import 'package:expense_tracker_app/core/common/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:expense_tracker_app/core/common/widgets/button/app_button.dart';
import 'package:expense_tracker_app/core/common/widgets/loading/loading.dart';
import 'package:expense_tracker_app/core/common/widgets/snack_bar/app_snack_bar.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/navigation/app_router.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_tracker_app/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:expense_tracker_app/features/category/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker_app/features/category/presentation/widgets/category_item.dart';
import 'package:expense_tracker_app/features/setting/domain/entities/setting_entity.dart';
import 'package:expense_tracker_app/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class AddOrEditBudgetPage extends StatefulWidget {
  const AddOrEditBudgetPage({
    super.key,
    required this.isEdit,
    this.budget,
  });

  final bool isEdit;
  final BudgetEntity? budget;

  @override
  State<AddOrEditBudgetPage> createState() => _AddOrEditBudgetPageState();
}

class _AddOrEditBudgetPageState extends State<AddOrEditBudgetPage> {
  final TextEditingController amountController = TextEditingController(text: '0');
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  String categoryId = '';
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  DateTime now = DateTime.now();
  DateTime? pickedDate;
  DateTime? startDate;
  DateTime? endDate;

  late SettingEntity settingEntity;

  @override
  void initState() {
    super.initState();
    settingEntity = context.read<SettingBloc>().state.setting;

    if (widget.isEdit) {
      if (widget.budget != null) {
        amountController.text = CurrencyFormatter.format(
          amount: widget.budget!.amountLimit,
          toCurrency: settingEntity.currency,
          isShowSymbol: false,
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          categoryController.text = GetLocalizedName.getLocalizedName(
            context,
            widget.budget!.category.name,
          );
        });

        categoryId = widget.budget!.category.categoryId;
        startDate = widget.budget!.startDate;
        endDate = widget.budget!.endDate.copyWith(day: widget.budget!.endDate.day - 1);
        startDateController.text = dateFormat.format(startDate!);
        endDateController.text = dateFormat.format(endDate!);
      }
    } else {
      startDate = now.firstDayOfMonth();
      endDate = now.lastDayOfMonth();
      startDateController.text = dateFormat.format(startDate!);
      endDateController.text = dateFormat.format(endDate!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    amountController.dispose();
    categoryController.dispose();
    startDateController.dispose();
    endDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BudgetBloc, BudgetState>(
      listener: (context, state) {
        if (state.status == BudgetStatus.loading) {
          Loading.show(context);
        }
        if (state.status == BudgetStatus.success) {
          Loading.hide(context);
          context.pop();
        }
        if (state.status == BudgetStatus.failure) {
          Loading.hide(context);
          AppSnackBar.showError(
              context, GetLocalizedName.getLocalizedName(context, state.errorMessage));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.violet100,
        appBar: CustomAppBar(
          title: widget.isEdit
              ? AppLocalizations.of(context)!.editBudget
              : AppLocalizations.of(context)!.addNewBudget,
          centerTitle: true,
          titleColor: AppColors.light100,
          foregroundColor: AppColors.light100,
          backgroundColor: AppColors.violet100,
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
                    AppLocalizations.of(context)!.howMuchDoYouWantToSpend,
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
                  child: _buildBudgetAmountField(context),
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
                        height: 32,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: _buildDateTimePickerField(
                                context: context,
                                label: AppLocalizations.of(context)!.startDate,
                                controller: startDateController,
                                onTap: () async {
                                  pickedDate = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2024),
                                      lastDate: DateTime(2030),
                                      initialDate: startDate);

                                  if (pickedDate != null && pickedDate != startDate) {
                                    startDate = DateTime(
                                        pickedDate!.year, pickedDate!.month, pickedDate!.day);
                                    startDateController.text = dateFormat.format(startDate!);
                                    pickedDate = null;
                                  }
                                }),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Flexible(
                            child: _buildDateTimePickerField(
                                context: context,
                                label: AppLocalizations.of(context)!.endDate,
                                controller: endDateController,
                                onTap: () async {
                                  pickedDate = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2024),
                                      lastDate: DateTime(2030),
                                      initialDate: endDate);

                                  if (pickedDate != null && pickedDate != endDate) {
                                    endDate = DateTime(
                                        pickedDate!.year, pickedDate!.month, pickedDate!.day);
                                    endDateController.text = dateFormat.format(endDate!);
                                    pickedDate = null;
                                  }
                                }),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 56,
                      ),
                      AppButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          double amountLimit = CurrencyFormatter.unFormat(
                            amount: amountController.text.trim(),
                            fromCurrency: settingEntity.currency,
                          );
                          if (amountController.text.isEmpty ||
                              categoryController.text.isEmpty ||
                              categoryId.isEmpty ||
                              startDateController.text.isEmpty ||
                              endDateController.text.isEmpty ||
                              amountLimit <= 0) {
                            AppSnackBar.showError(context, AppLocalizations.of(context)!.fillIn);
                            return;
                          }

                          if (endDate!.difference(startDate!).isNegative) {
                            AppSnackBar.showError(context,
                                AppLocalizations.of(context)!.endDateCanNotBeBeforeStartDate);
                            return;
                          }

                          if (endDate!.difference(now).isNegative) {
                            AppSnackBar.showError(context,
                                AppLocalizations.of(context)!.endDateCanNotBeLessThanToday);
                            return;
                          }

                          if (widget.isEdit) {
                            context.read<BudgetBloc>().add(
                                  BudgetEdited(
                                    budgetId: widget.budget!.budgetId,
                                    categoryId: categoryId,
                                    amountLimit: amountLimit,
                                    startDate: startDate!,
                                    endDate:
                                        DateTime(endDate!.year, endDate!.month, endDate!.day + 1),
                                  ),
                                );
                          } else {
                            context.read<BudgetBloc>().add(
                                  BudgetAdded(
                                    categoryId: categoryId,
                                    amountLimit: amountLimit,
                                    startDate: startDate!,
                                    endDate:
                                        DateTime(endDate!.year, endDate!.month, endDate!.day + 1),
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

  Widget _buildBudgetAmountField(BuildContext context) {
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
              return Scaffold(
                appBar: CustomAppBar(
                  title: AppLocalizations.of(context)!.expense,
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
                      state.userCategoriesExpense.isEmpty
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
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return CategoryItem(
                                  categoryEntity: state.userCategoriesExpense[index],
                                  onTap: () {
                                    categoryController.text = GetLocalizedName.getLocalizedName(
                                      context,
                                      state.userCategoriesExpense[index].name,
                                    );
                                    categoryId = state.userCategoriesExpense[index].categoryId;
                                    context.pop();
                                  },
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 16,
                                );
                              },
                              itemCount: state.userCategoriesExpense.length,
                            ),
                      const SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AppButton(
                          onPressed: () {
                            context.push(RoutePaths.category + RoutePaths.addOrEditCategory,
                                extra: ({
                                  'isEdit': false,
                                }));
                          },
                          buttonText: AppLocalizations.of(context)!.addNewCategory,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
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
                            categoryEntity: state.defaultCategoriesExpense[index],
                            onTap: () {
                              categoryController.text = GetLocalizedName.getLocalizedName(
                                context,
                                state.defaultCategoriesExpense[index].name,
                              );
                              categoryId = state.defaultCategoriesExpense[index].categoryId;
                              context.pop();
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 16,
                          );
                        },
                        itemCount: state.defaultCategoriesExpense.length,
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

  Widget _buildDateTimePickerField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              color: AppColors.dark100,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: controller,
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
          onTap: onTap,
        ),
      ],
    );
  }
}
