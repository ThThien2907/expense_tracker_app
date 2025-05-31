import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/category/domain/entities/category_entity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PieChartReport extends StatelessWidget {
  const PieChartReport({
    super.key,
    required this.pieChartData,
    required this.isExpense,
  });

  final Map<String, dynamic> pieChartData;
  final bool isExpense;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.3,
      child: AspectRatio(
        aspectRatio: 1.2,
        child: PieChart(
          key: ValueKey(
              isExpense ? pieChartData['expense'] : pieChartData['income']),
          PieChartData(
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 0,
            sections: showingSections(),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    final data = isExpense ? pieChartData['expense'] : pieChartData['income'];
    final categories = data['categories'] as List;

    if (categories.isEmpty) {
      return List.generate(
        1,
        (i) => PieChartSectionData(
          color: AppColors.light60,
          radius: 100,
        ),
      );
    }

    final double totalAmount = data['totalAmount'];
    return List.generate(categories.length, (i) {
      final CategoryEntity categoryEntity = categories[i]['category'];
      final color =
          Color(int.parse('0xff${categoryEntity.color.replaceAll('#', '')}'));
      double value = categories[i]['totalAmountOfCategory'] / totalAmount * 100;
      value = double.parse(value.toStringAsFixed(2));

      return PieChartSectionData(
        color: color,
        value: value,
        title: '$value%',
        radius: 100,
        titleStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.light80,
        ),
        badgeWidget: _Badge(
          'assets/vectors/category/${categoryEntity.iconName}',
          size: 40,
          borderColor: color,
        ),
        badgePositionPercentageOffset: 1.08,
      );
    });
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.svgAsset, {
    required this.size,
    required this.borderColor,
  });

  final String svgAsset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: SvgPicture.asset(
          svgAsset,
          colorFilter: ColorFilter.mode(borderColor, BlendMode.srcIn),
        ),
      ),
    );
  }
}
