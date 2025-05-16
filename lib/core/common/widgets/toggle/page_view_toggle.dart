import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PageViewToggle extends StatelessWidget {
  const PageViewToggle({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.labels,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.light60,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(6),
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: Stack(
          children: [
            AnimatedAlign(
              alignment: Alignment.lerp(
                Alignment.centerLeft,
                Alignment.centerRight,
                labels.length == 1 ? 0.0 : selectedIndex / (labels.length - 1),
              )!,
              duration: const Duration(milliseconds: 300),
              child: Material(
                color: AppColors.violet100,
                borderRadius: BorderRadius.circular(30),
                child: FractionallySizedBox(
                  widthFactor: 1 / labels.length,
                  child: const SizedBox(
                    height: 60,
                  ),
                ),
              ),
            ),
            Row(
              children: labels.asMap().entries.map((entry) {
                final index = entry.key;
                final label = entry.value;
                final isSelected = index == selectedIndex;

                return Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () => onItemSelected(index),
                    child: Center(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: isSelected ? AppColors.light100 : AppColors.dark75,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
