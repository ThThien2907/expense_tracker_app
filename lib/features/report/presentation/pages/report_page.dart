import 'package:expense_tracker_app/core/assets/app_vectors.dart';
import 'package:expense_tracker_app/core/common/extensions/currency_formatter.dart';
import 'package:expense_tracker_app/core/common/extensions/get_localized_name.dart';
import 'package:expense_tracker_app/core/common/widgets/app_bar/custom_app_bar.dart';
import 'package:expense_tracker_app/core/common/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:expense_tracker_app/core/common/widgets/button/month_picker_button.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/report/presentation/pages/line_chart_report_page.dart';
import 'package:expense_tracker_app/features/report/presentation/pages/pie_chart_report_page.dart';
import 'package:expense_tracker_app/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:expense_tracker_app/features/wallet/domain/entities/wallet_entity.dart';
import 'package:expense_tracker_app/features/wallet/presentation/bloc/cubit/selected_wallet_cubit.dart';
import 'package:expense_tracker_app/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:expense_tracker_app/features/wallet/presentation/widgets/wallet_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  DateTime _initialDate = DateTime.now();
  DateFormat dateFormat = DateFormat('MM/yyyy');

  bool _isLineChart = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.financialReport,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            BlocBuilder<SelectedWalletCubit, WalletEntity?>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${AppLocalizations.of(context)!.walletBalance}: ${GetLocalizedName.getLocalizedName(context, state!.name)}',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: AppColors.light20,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            CurrencyFormatter.format(
                              amount: state.balance,
                              toCurrency: context.read<SettingBloc>().state.setting.currency,
                            ),
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.dark75,
                            ),
                            overflow: TextOverflow.ellipsis,
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
                          AppBottomSheet.show(
                            context: context,
                            height: MediaQuery.of(context).size.height * 0.85,
                            widget: BlocProvider.value(
                              value: context.read<SelectedWalletCubit>(),
                              child: _buildWalletSelectedPage(context),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 14, right: 8),
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              width: 2,
                              color: AppColors.light60,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.changeWallet,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.dark50,
                                ),
                                overflow: TextOverflow.ellipsis,
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
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MonthPickerButton(
                  initialDate: _initialDate,
                  onTap: (date) {
                    setState(() {
                      _initialDate = date.lastDayOfMonth()!;
                    });
                  },
                ),
                Row(
                  children: [
                    Material(
                      color: _isLineChart
                          ? AppColors.violet100
                          : AppColors.light100,
                      borderRadius:
                          const BorderRadius.horizontal(left: Radius.circular(16)),
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.horizontal(left: Radius.circular(16)),
                        onTap: () {
                          if (_isLineChart == false) {
                            setState(() {
                              _isLineChart = true;
                            });
                          }
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(16)),
                            border: Border.all(
                              width: 2,
                              color: _isLineChart
                                  ? AppColors.violet100
                                  : AppColors.light60,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            AppVectors.lineChartIcon,
                            height: 32,
                            colorFilter: ColorFilter.mode(
                              _isLineChart
                                  ? AppColors.light100
                                  : AppColors.violet100,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: _isLineChart
                          ? AppColors.light100
                          : AppColors.violet100,
                      borderRadius:
                          const BorderRadius.horizontal(right: Radius.circular(16)),
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.horizontal(right: Radius.circular(16)),
                        onTap: () {
                          if (_isLineChart == true) {
                            setState(() {
                              _isLineChart = false;
                            });
                          }
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(16)),
                            border: Border.all(
                              width: 2,
                              color: _isLineChart
                                  ? AppColors.light60
                                  : AppColors.violet100,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            AppVectors.budgetIcon,
                            height: 32,
                            colorFilter: ColorFilter.mode(
                              _isLineChart
                                  ? AppColors.violet100
                                  : AppColors.light100,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            _isLineChart
                ? Expanded(
                    child: LineChartReportPage(
                      initialDate: _initialDate,
                    ),
                  )
                : Expanded(
                  child: PieChartReportPage(
                      initialDate: _initialDate,
                    ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletSelectedPage(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.wallet,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, state) {
            return ListView.builder(
              itemCount: state.wallets.length,
              itemBuilder: (context, index) {
                return WalletItem(
                  wallet: state.wallets[index],
                  onTap: () {
                    if (context.read<SelectedWalletCubit>().state!.walletId !=
                        state.wallets[index].walletId) {
                      context
                          .read<SelectedWalletCubit>()
                          .setWallet(state.wallets[index]);
                    }
                    context.pop();
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
