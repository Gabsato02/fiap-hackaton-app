import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesChart extends StatelessWidget {
  final String title;
  final Map<String, double> data;
  final List<Color> colors;
  final bool isLoading;

  const SalesChart({
    super.key,
    required this.title,
    required this.data,
    required this.colors,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final total = data.values.fold(0.0, (a, b) => a + b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: _buildSections(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: data.entries.map((entry) {
            final index = data.keys.toList().indexOf(entry.key);
            final color = colors[index % colors.length];
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: color,
                  radius: 6,
                ),
                const SizedBox(width: 6),
                Text(
                    '${entry.key} (${(entry.value / total * 100).toStringAsFixed(1)}%)'),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildSections() {
    final total = data.values.fold(0.0, (a, b) => a + b);

    return data.entries.map((entry) {
      final index = data.keys.toList().indexOf(entry.key);
      final percentage = (entry.value / total) * 100;
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: entry.value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
