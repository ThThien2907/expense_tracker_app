import 'package:expense_tracker_app/core/common/widgets/app_bar/custom_app_bar.dart';
import 'package:expense_tracker_app/core/common/widgets/button/app_button.dart';
import 'package:expense_tracker_app/core/common/widgets/toggle/page_view_toggle.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/navigation/app_router.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/category/domain/entities/category_entity.dart';
import 'package:expense_tracker_app/features/category/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker_app/features/category/presentation/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int _selectedIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.category,
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: PageViewToggle(
                    labels: [
                      AppLocalizations.of(context)!.expense,
                      AppLocalizations.of(context)!.income
                    ],
                    selectedIndex: _selectedIndex,
                    onItemSelected: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: _selectedIndex == 0
                        ? _buildCategoriesListView(
                            context: context,
                            defaultCategories: state.defaultCategoriesExpense,
                            userCategories: state.userCategoriesExpense,
                          )
                        : _buildCategoriesListView(
                            context: context,
                            defaultCategories: state.defaultCategoriesIncome,
                            userCategories: state.userCategoriesIncome,
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
                  child: AppButton(
                    onPressed: () {
                      context.push(RoutePaths.category + RoutePaths.addOrEditCategory, extra: ({
                        'isEdit': false,
                      }));
                    },
                    buttonText: AppLocalizations.of(context)!.addNewCategory,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoriesListView({
    required BuildContext context,
    required List<CategoryEntity> defaultCategories,
    required List<CategoryEntity> userCategories,
  }) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
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
                  padding: const EdgeInsets.only(bottom: 16),
                  itemBuilder: (context, index) {
                    return CategoryItem(
                      categoryEntity: userCategories[index],
                      onTap: () {
                        context.push(RoutePaths.category + RoutePaths.addOrEditCategory, extra: ({
                          'isEdit': true,
                          'category': userCategories[index],
                        }));
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
    );
  }
}
