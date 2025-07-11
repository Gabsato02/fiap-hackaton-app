import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesChart extends StatelessWidget {
  final String title;
  final Map<String, int> data;
  final bool isLoading;

  SalesChart({
    super.key,
    required this.title,
    required this.data,
    this.isLoading = false,
  }) : colors = _generateColors(data.keys);

  final Map<String, Color> colors;

  static Map<String, Color> _generateColors(Iterable<String> keys) {
    final random = Random();
    return {
      for (var key in keys)
        key: Color.fromARGB(
          255,
          random.nextInt(200) + 30, // evita tons muito escuros
          random.nextInt(200) + 30,
          random.nextInt(200) + 30,
        )
    };
  }

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
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 6,
                  backgroundColor: colors[entry.key],
                ),
                const SizedBox(width: 6),
                Text(
                  '${entry.key} (${(entry.value / total * 100).toStringAsFixed(0)}%)',
                ),
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
      final percentage = (entry.value / total) * 100;
      return PieChartSectionData(
        value: entry.value.toDouble(),
        title: '${percentage.toStringAsFixed(0)}%',
        color: colors[entry.key],
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
