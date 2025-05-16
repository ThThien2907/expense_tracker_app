import 'package:expense_tracker_app/core/common/widgets/app_bar/custom_app_bar.dart';
import 'package:expense_tracker_app/core/common/widgets/toggle/page_view_toggle.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/features/category/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker_app/features/category/presentation/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

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
                const SizedBox(height: 8,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16,),
                  child: PageViewToggle(
                    labels: [
                      AppLocalizations.of(context)!.expense,
                      AppLocalizations.of(context)!.income
                    ],
                    selectedIndex: _selectedIndex,
                    onItemSelected: (index) {
                      setState(() {
                        _selectedIndex = index;
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 1),
                          curve: Curves.easeInOut,
                        );
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return index == 0 ?
                         ListView.separated(
                           itemBuilder: (context, itemIndex) {
                             return CategoryItem(
                               name: state.categoriesExpense[itemIndex].name,
                               iconName: state.categoriesExpense[itemIndex].iconName,
                               color: state.categoriesExpense[itemIndex].color,
                             );
                           },
                           separatorBuilder: (context, index) {
                             return const SizedBox(
                               height: 16,
                             );
                           },
                           itemCount: state.categoriesExpense.length,
                         ) : ListView.separated(
                           itemBuilder: (context, itemIndex) {
                             return CategoryItem(
                               name: state.categoriesIncome[itemIndex].name,
                               iconName: state.categoriesIncome[itemIndex].iconName,
                               color: state.categoriesIncome[itemIndex].color,
                             );
                           },
                           separatorBuilder: (context, index) {
                             return const SizedBox(
                               height: 16,
                             );
                           },
                           itemCount: state.categoriesIncome.length,
                         );
                      },
                      onPageChanged: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
