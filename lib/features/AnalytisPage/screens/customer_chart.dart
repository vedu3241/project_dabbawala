import 'dart:math';

import 'package:dabbawala/features/AnalytisPage/models/analytic_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomerChart extends StatelessWidget {
  final List<DabbawalaStat> stats;
  final Function(DabbawalaStat) onMonthSelected;

  const CustomerChart({
    Key? key,
    required this.stats,
    required this.onMonthSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: stats.map((e) => e.customerCount).reduce(max) * 1.2,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            // tooltipBgColor: Colors.blueAccent,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              if (groupIndex >= 0 && groupIndex < stats.length) {
                return BarTooltipItem(
                  '${stats[groupIndex].month}: ${stats[groupIndex].customerCount} customers',
                  const TextStyle(color: Colors.white),
                );
              }
              return null;
            },
          ),
          touchCallback: (FlTouchEvent event, barTouchResponse) {
            if (event is FlTapUpEvent && barTouchResponse?.spot != null) {
              final spotIndex = barTouchResponse!.spot!.touchedBarGroupIndex;
              if (spotIndex >= 0 && spotIndex < stats.length) {
                onMonthSelected(stats[spotIndex]);
              }
            }
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value < 0 || value >= stats.length) {
                  return const Text('');
                }
                return Text(
                  stats[value.toInt()].month,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 10,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        barGroups: List.generate(stats.length, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: stats[index].customerCount.toDouble(),
                color: Colors.blue,
                width: 16,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }),
        gridData: FlGridData(
          show: true,
          checkToShowHorizontalLine: (value) => value % 10 == 0,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.black12,
            strokeWidth: 1,
          ),
        ),
      ),
    );
  }
}
