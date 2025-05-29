import 'package:expense_tracker_app/core/assets/app_vectors.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/navigation/app_router.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AppBottomNavigationBar extends StatefulWidget {
  final StatefulNavigationShell statefulNavigationShell;

  const AppBottomNavigationBar(
      {super.key, required this.statefulNavigationShell});

  static const routes = [
    RoutePaths.home,
    RoutePaths.transaction,
    RoutePaths.budget,
    RoutePaths.account,
  ];

  static const icons = [
    AppVectors.homeIcon,
    AppVectors.transactionIcon,
    AppVectors.budgetIcon,
    AppVectors.accountIcon,
  ];

  static List<String> labels(BuildContext context) => [
        AppLocalizations.of(context)!.home,
        AppLocalizations.of(context)!.transactions,
        AppLocalizations.of(context)!.budgets,
        AppLocalizations.of(context)!.account,
      ];

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  @override
  void initState() {
    super.initState();
    // context
    //     .read<WalletBloc>()
    //     .add(WalletStarted(userId: context.read<AppUserCubit>().state!.userId));
    // context.read<CategoryBloc>().add(CategoryStarted());
    // context
    //     .read<BudgetBloc>()
    //     .add(BudgetStarted(userId: context.read<AppUserCubit>().state!.userId));
    // context
    //     .read<TransactionBloc>()
    //     .add(TransactionStarted(userId: context.read<AppUserCubit>().state!.userId));
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    int selectedIndex = 0;
    if (currentRoute.startsWith('/home')) {
      selectedIndex = 0;
    } else if (currentRoute.startsWith('/transaction')) {
      selectedIndex = 1;
    } else if (currentRoute.startsWith('/budget')) {
      selectedIndex = 2;
    } else if (currentRoute.startsWith('/account')) {
      selectedIndex = 3;
    }

    return Scaffold(
      extendBody: true,
      floatingActionButton: _buildFloatingActionButton(
        backgroundColor: AppColors.violet100,
        iconData: Icons.add,
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return Stack(
                children: [
                  Positioned(
                    bottom: 120,
                    left: MediaQuery.of(context).size.width / 2 - 100,
                    child: _buildFloatingActionButton(
                      backgroundColor: AppColors.red100,
                      onTap: () {
                        context.pop();
                        context.push(
                          RoutePaths.addOrEditTransaction,
                          extra: ({'isExpense': true}),
                        );
                      },
                      svgIcon: AppVectors.expenseIcon,
                    ),
                  ),
                  Positioned(
                    bottom: 120,
                    right: MediaQuery.of(context).size.width / 2 - 100,
                    child: _buildFloatingActionButton(
                      backgroundColor: AppColors.green100,
                      onTap: () {
                        context.pop();

                        context.push(
                          RoutePaths.addOrEditTransaction,
                          extra: ({'isExpense': false}),
                        );
                      },
                      svgIcon: AppVectors.incomeIcon,
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0, 0.895),
                    child: _buildFloatingActionButton(
                      backgroundColor: AppColors.violet100,
                      iconData: Icons.close,
                      size: 62,
                      onTap: () {
                        context.pop();
                      },
                      // svgIcon: AppVectors.incomeIcon,
                    ),
                  ),
                ],
              );
            },
          ).then((value) {
            if (value == null) {
              debugPrint('dong dialog');
            }
          });
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      body: widget.statefulNavigationShell,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        color: AppColors.light80,
        height: 70,
        elevation: 4,
        shadowColor: AppColors.dark100,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            4,
            (index) {
              return Padding(
                padding: index == 1
                    ? const EdgeInsets.only(right: 24)
                    : index == 2
                    ? const EdgeInsets.only(left: 24)
                    : EdgeInsets.zero,
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: AppColors.violet20.withValues(alpha: 0.4),
                  onTap: () {
                    widget.statefulNavigationShell.goBranch(index);
                  },
                  child: SizedBox(
                    width: 74,
                    // padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppBottomNavigationBar.icons[index],
                          colorFilter: ColorFilter.mode(
                            index == selectedIndex
                                ? AppColors.violet100
                                : AppColors.light20,
                            BlendMode.srcIn,
                          ),
                          height: 28,
                        ),
                        Text(
                          AppBottomNavigationBar.labels(context)[index],
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: index == selectedIndex
                                ? AppColors.violet100
                                : AppColors.light20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton({
    required Color backgroundColor,
    required VoidCallback onTap,
    String? svgIcon,
    IconData? iconData,
    double? size,
  }) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(1000),
      child: InkWell(
        borderRadius: BorderRadius.circular(1000),
        onTap: onTap,
        child: Container(
          width: size ?? 60,
          height: size ?? 60,
          alignment: Alignment.center,
          child: svgIcon != null
              ? SvgPicture.asset(
                  svgIcon,
                  height: 32,
                  colorFilter: const ColorFilter.mode(
                    AppColors.light100,
                    BlendMode.srcIn,
                  ),
                )
              : Center(
                  child: Icon(
                    iconData,
                    color: AppColors.light100,
                    size: 32,
                  ),
                ),
        ),
      ),
    );
  }
}
