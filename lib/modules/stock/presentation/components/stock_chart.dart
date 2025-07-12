import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fiap_hackaton_app/domain/entities/index.dart';
import 'dart:math';

class StockChart extends StatelessWidget {
  final List<Product> products;

  const StockChart({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Container(
        height: 150,
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: const Center(
            child: Text(
              'Adicione produtos para ver o gráfico.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      );
    }

    final barGroups = <BarChartGroupData>[];
    for (var i = 0; i < products.length; i++) {
      final product = products[i];
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: product.quantity.toDouble(),
              color: Colors.primaries[
                  i % Colors.primaries.length], // Cores mais consistentes
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1.5,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: (products.map((p) => p.quantity).reduce(max) * 1.2),
              barGroups: barGroups,
              titlesData: FlTitlesData(
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= products.length)
                        return const SizedBox();

                      return SideTitleWidget(
                        meta: meta,
                        child: Text(
                          products[index].name.split(' ').first,
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: true, drawVerticalLine: false),
            ),
          ),
        ),
      ),
    );
  }
}
