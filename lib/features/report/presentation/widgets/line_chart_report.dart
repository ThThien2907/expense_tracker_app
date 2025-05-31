import 'package:expense_tracker_app/core/common/extensions/currency_formatter.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LineChartReport extends StatelessWidget {
  const LineChartReport(
      {super.key, required this.chartData, required this.isExpense});

  final Map<String, dynamic> chartData;
  final bool isExpense;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 24,
          bottom: 12,
        ),
        child: LineChart(
          lineChartData(
            context: context,
            data: chartData['flSpot'],
            scaleFactor: chartData['scaleFactor'],
            max: chartData['maxAmount'],
            suffix: chartData['suffix'],
          ),
        ),
      ),
    );
  }

  LineChartData lineChartData({
    required BuildContext context,
    required List<FlSpot> data,
    required int scaleFactor,
    required double max,
    required String suffix,
  }) {
    double ratio = max / scaleFactor;
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: ratio < 5 ? 1 : 2,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppColors.light40,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            interval: generateIntervalBottomTitles(data.length),
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  (value.toInt() + 1).toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: ratio < 5 ? 1 : 2,
            getTitlesWidget: (value, meta) {
              return Text(
                "${(value).toStringAsFixed(0)}${value != 0 ? suffix : ''}",
                style: const TextStyle(fontSize: 12),
              );
            },
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(top: BorderSide(color: AppColors.light40))),
      lineTouchData: LineTouchData(
        getTouchedSpotIndicator: (barData, indicators) {
          return indicators.map((int index) {
            return TouchedSpotIndicatorData(
              const FlLine(color: Colors.transparent, strokeWidth: 0),
              FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, index) =>
                    FlDotCirclePainter(
                      strokeWidth: 4,
                      color: bar.gradient?.colors.first ??
                          bar.color ??
                          Colors.blueGrey,
                      strokeColor: bar.gradient?.colors.first ??
                          bar.color ??
                          Colors.blueGrey,
                    ),
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
          maxContentWidth: 160,
          getTooltipColor: (touchedSpots) => AppColors.light60,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final day = touchedSpot.x.toInt() + 1;
              final amount = touchedSpot.y;
              final label = isExpense
                  ? AppLocalizations.of(context)!.expense
                  : AppLocalizations.of(context)!.income;

              return LineTooltipItem(
                '',
                const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  color: AppColors.dark75,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: '$label\n',
                  ),
                  TextSpan(
                    text: '${AppLocalizations.of(context)!.day} $day\n',
                  ),
                  TextSpan(
                    text: CurrencyFormatter.format(
                      amount: amount * scaleFactor,
                      fromCurrency:
                      context
                          .read<SettingBloc>()
                          .state
                          .setting
                          .currency,
                      toCurrency:
                      context
                          .read<SettingBloc>()
                          .state
                          .setting
                          .currency,
                    ),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      color: isExpense ? AppColors.red100 : AppColors.green100,
                      fontSize: 16,
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
      ),
      minX: 0,
      minY: 0,
      maxY: ((ratio + 1).toInt()).toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: data,
          isCurved: true,
          curveSmoothness: 0.01,
          gradient: LinearGradient(
            colors: isExpense
                ? [
              AppColors.red100,
              AppColors.red100,
            ]
                : [
              AppColors.green100,
              AppColors.green100,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: isExpense
                  ? [
                AppColors.red100.withValues(alpha: 0.3),
                AppColors.red20.withValues(alpha: 0.3),
              ]
                  : [
                AppColors.green100.withValues(alpha: 0.3),
                AppColors.green20.withValues(alpha: 0.3),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  double generateIntervalBottomTitles(int dataLength) {
     if (dataLength < 7) {
       return 1;
     } else if (dataLength < 14) {
       return 2;
     } else if (dataLength < 21) {
       return 3;
     } else {
       return 5;
     }
  }
}
