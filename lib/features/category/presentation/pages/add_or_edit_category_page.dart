import 'package:expense_tracker_app/core/assets/app_vectors.dart';
import 'package:expense_tracker_app/core/common/constant/app_const.dart';
import 'package:expense_tracker_app/core/common/extensions/get_localized_name.dart';
import 'package:expense_tracker_app/core/common/widgets/app_bar/custom_app_bar.dart';
import 'package:expense_tracker_app/core/common/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:expense_tracker_app/core/common/widgets/button/app_button.dart';
import 'package:expense_tracker_app/core/common/widgets/icon/app_icon.dart';
import 'package:expense_tracker_app/core/common/widgets/loading/loading.dart';
import 'package:expense_tracker_app/core/common/widgets/snack_bar/app_snack_bar.dart';
import 'package:expense_tracker_app/core/common/widgets/text_field/app_text_field.dart';
import 'package:expense_tracker_app/core/common/widgets/toggle/page_view_toggle.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:expense_tracker_app/features/category/domain/entities/category_entity.dart';
import 'package:expense_tracker_app/features/category/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker_app/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AddOrEditCategoryPage extends StatefulWidget {
  const AddOrEditCategoryPage({
    super.key,
    required this.isEdit,
    this.categoryEntity,
  });

  final bool isEdit;
  final CategoryEntity? categoryEntity;

  @override
  State<AddOrEditCategoryPage> createState() => _AddOrEditCategoryPageState();
}

class _AddOrEditCategoryPageState extends State<AddOrEditCategoryPage> {
  final TextEditingController nameController = TextEditingController();
  int _selectedCategoryIndex = 0;
  int _selectedTypeIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _selectedCategoryIndex = AppConst.icons.indexWhere(
        (e) => e['icon_name'] == widget.categoryEntity!.iconName,
      );
      _selectedTypeIndex = widget.categoryEntity!.type;
      nameController.text = widget.categoryEntity!.name;
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String selectedIcon =
        'assets/vectors/category/${AppConst.icons[_selectedCategoryIndex]['icon_name']}';
    String selectedColor =
        '0xff${AppConst.icons[_selectedCategoryIndex]['color']!.replaceFirst('#', '')}';
    return BlocListener<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state.status == CategoryStatus.loading) {
          Loading.show(context);
        }
        if (state.status == CategoryStatus.failure) {
          Loading.hide(context);
          AppSnackBar.showError(
            context,
            GetLocalizedName.getLocalizedName(context, state.errorMessage),
          );
        }
        if (state.status == CategoryStatus.success) {
          Loading.hide(context);
          context.pop();
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.isEdit
              ? AppLocalizations.of(context)!.editCategory
              : AppLocalizations.of(context)!.addNewCategory,
          centerTitle: true,
          action: [
            if (widget.isEdit)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: IconButton(
                  onPressed: () {
                    AppBottomSheet.show(
                      context: context,
                      widget: ConfirmEventBottomSheet(
                        title: AppLocalizations.of(context)!.removeThisCategory,
                        subtitle: AppLocalizations.of(context)!.confirmRemoveCategory,
                        onPressedYesButton: () {
                          context.pop();
                          context.read<CategoryBloc>().add(
                                CategoryRemoved(
                                  categoryId: widget.categoryEntity!.categoryId,
                                  transactionBloc: context.read<TransactionBloc>(),
                                  budgetBloc: context.read<BudgetBloc>(),
                                  walletBloc: context.read<WalletBloc>(),
                                ),
                              );
                        },
                      ),
                    );
                  },
                  icon: SvgPicture.asset(
                    AppVectors.deleteIcon,
                    colorFilter: const ColorFilter.mode(
                      AppColors.dark75,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(
                height: 32,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppIcon(
                    icon: selectedIcon,
                    size: 56,
                    iconSize: 32,
                    iconColor: Color(int.parse(selectedColor)),
                    backgroundIconColor: Color(int.parse(selectedColor)).withValues(alpha: 0.3),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(
                          controller: nameController,
                          hintText: AppLocalizations.of(context)!.name,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        widget.isEdit
                            ? Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  '${AppLocalizations.of(context)!.type}: ${widget.categoryEntity!.type == 0 ? AppLocalizations.of(context)!.expense : AppLocalizations.of(context)!.income}',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: AppColors.dark75,
                                  ),
                                ),
                              )
                            : PageViewToggle(
                                selectedIndex: _selectedTypeIndex,
                                onItemSelected: (index) {
                                  setState(() {
                                    _selectedTypeIndex = index;
                                  });
                                },
                                labels: [
                                  AppLocalizations.of(context)!.expense,
                                  AppLocalizations.of(context)!.income,
                                ],
                                height: 50,
                                width: 230,
                              )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemBuilder: (context, index) {
                    String color = '0xff${AppConst.icons[index]['color']!.replaceFirst('#', '')}';
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: AppIcon(
                          icon: 'assets/vectors/category/${AppConst.icons[index]['icon_name']}',
                          size: 56,
                          iconSize: 44,
                          iconColor: _selectedCategoryIndex == index
                              ? Color(int.parse(color))
                              : AppColors.light20,
                          backgroundIconColor: _selectedCategoryIndex == index
                              ? Color(int.parse(color)).withValues(alpha: 0.3)
                              : AppColors.light60,
                        ),
                      ),
                    );
                  },
                  itemCount: AppConst.icons.length,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              AppButton(
                onPressed: () {
                  if (nameController.text.isEmpty) {
                    AppSnackBar.showError(context, AppLocalizations.of(context)!.fillIn);
                    return;
                  }

                  if (widget.isEdit) {
                    context.read<CategoryBloc>().add(CategoryEdited(
                          categoryId: widget.categoryEntity!.categoryId,
                          name: nameController.text.trim(),
                          iconName: AppConst.icons[_selectedCategoryIndex]['icon_name']!,
                          color: AppConst.icons[_selectedCategoryIndex]['color']!,
                          transactionBloc: context.read<TransactionBloc>(),
                          budgetBloc: context.read<BudgetBloc>(),
                        ));
                  } else {
                    context.read<CategoryBloc>().add(CategoryAdded(
                          name: nameController.text.trim(),
                          iconName: AppConst.icons[_selectedCategoryIndex]['icon_name']!,
                          color: AppConst.icons[_selectedCategoryIndex]['color']!,
                          type: _selectedTypeIndex,
                        ));
                  }
                },
                buttonText: AppLocalizations.of(context)!.apply,
              ),
              const SizedBox(
                height: 32,
              )
            ],
          ),
        ),
      ),
    );
  }
}
