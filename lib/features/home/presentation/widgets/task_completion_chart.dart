import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme_extension.dart';

class TaskCompletionChart extends StatelessWidget {
  final AppThemeExtension theme;
  final int completed;
  final int pending;

  const TaskCompletionChart({
    super.key,
    required this.theme,
    required this.completed,
    required this.pending,
  });

  @override
  Widget build(BuildContext context) {
    final total = completed + pending;
    final completedPercentage = total > 0 ? (completed / total * 100).toStringAsFixed(0) : '0';

    return Container(
      padding: EdgeInsets.all(theme.spacingLG),
      decoration: BoxDecoration(
        color: theme.surfaceContainer,
        borderRadius: BorderRadius.circular(theme.radiusLG),
        border: Border.all(color: theme.borderSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Task Completion',
            style: theme.titleSmall.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 35,
                    startDegreeOffset: -90,
                    sections: [
                      PieChartSectionData(
                        value: completed.toDouble(),
                        color: theme.accent,
                        radius: 12,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: pending.toDouble(),
                        color: theme.primary.withValues(alpha: 0.2),
                        radius: 10,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$completedPercentage%',
                      style: theme.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.textPrimary,
                      ),
                    ),
                    Text(
                      'Done',
                      style: theme.labelSmall.copyWith(
                        color: theme.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _LegendItem(label: 'Completed', color: theme.accent, theme: theme),
              _LegendItem(label: 'Pending', color: theme.primary.withValues(alpha: 0.2), theme: theme),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  final AppThemeExtension theme;

  const _LegendItem({required this.label, required this.color, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.labelSmall.copyWith(fontSize: 10, color: theme.textSecondary),
        ),
      ],
    );
  }
}
