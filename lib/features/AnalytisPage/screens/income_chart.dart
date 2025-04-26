import 'dart:math';

import 'package:dabbawala/features/AnalytisPage/models/analytic_model.dart';
import 'package:dabbawala/features/AnalytisPage/models/dab_income_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class IncomeChart extends StatelessWidget {
  final List<DabbawalaIcomeStat> stats;
  final Function(DabbawalaIcomeStat) onMonthSelected;

  const IncomeChart({
    Key? key,
    required this.stats,
    required this.onMonthSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 5000,
          verticalInterval: 1,
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
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
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 5000,
              getTitlesWidget: (value, meta) {
                return Text(
                  '₹${value.toInt()}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                );
              },
              reservedSize: 42,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        minX: 0,
        maxX: stats.length - 1,
        minY: 0,
        maxY: stats.map((e) => e.income).reduce(max) * 1.2,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            // tooltipBgColor: Colors.greenAccent,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((LineBarSpot touchedSpot) {
                final index = touchedSpot.x.toInt();
                if (index >= 0 && index < stats.length) {
                  return LineTooltipItem(
                    '${stats[index].month}: ₹${stats[index].income.toInt()}',
                    const TextStyle(color: Colors.black),
                  );
                }
                return null;
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
          touchCallback:
              (FlTouchEvent event, LineTouchResponse? touchResponse) {
            if (event is FlTapUpEvent &&
                touchResponse?.lineBarSpots != null &&
                touchResponse!.lineBarSpots!.isNotEmpty) {
              final spotIndex = touchResponse.lineBarSpots!.first.x.toInt();
              if (spotIndex >= 0 && spotIndex < stats.length) {
                onMonthSelected(stats[spotIndex]);
              }
            }
          },
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(stats.length, (index) {
              return FlSpot(index.toDouble(), stats[index].income);
            }),
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.green,
                  strokeWidth: 1,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}
