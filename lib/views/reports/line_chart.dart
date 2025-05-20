import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class DateLineChart extends StatelessWidget {

  // const DateLineChart({super.key});
  const DateLineChart({super.key});

  @override
  Widget build(BuildContext context) {

    final List<DateTime> dates = [
      DateTime(2024, 1, 1),
      DateTime(2024, 2, 1),
      DateTime(2024, 3, 1),
      DateTime(2024, 4, 1),
      DateTime(2024, 5, 1),
    ];

    // final List<double> values = [1, 1.5, 1.4, 3.4, 2];
    final Random random = Random();
    final List<double> values = List.generate(10, (_) => random.nextDouble());
    final List<double> valuesB = List.generate(10, (_) => random.nextDouble());

    return LineChart(
      LineChartData(
        minY: 0,  // minimum value on Y-axis
        maxY: 1,  // maximum value on Y-axis
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final int index = value.toInt();
                if (index < 0 || index >= dates.length) return const SizedBox();
                final String formatted = DateFormat('yyyy-MM').format(dates[index]);
                return Text(formatted, style: const TextStyle(fontSize: 10));
              },
              interval: 1,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 0.25, // or whatever interval you want
              getTitlesWidget: (value, meta) {
                final text = "${(value * 100).toStringAsFixed(0)}%";

                return Text(
                  text,
                  style: const TextStyle(fontSize: 10),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                );
              },
              reservedSize: 30, // adjust width to fit your labels nicely
            ),
          ),

          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              dates.length,
              (i) => FlSpot(i.toDouble(), values[i]),
            ),
            isCurved: true,
            color: Colors.blue,
            dotData: FlDotData(show: true),
          ),
          LineChartBarData(
            spots: List.generate(
              dates.length,
              (i) => FlSpot(i.toDouble(), valuesB[i]),
            ),
            isCurved: true,
            color: Colors.red,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}
