import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarChartStringDouble extends StatelessWidget {

  final String chartTitle;
  final String yAxisTitle;
  final NumberFormat yAxisNumberFormat;

  const BarChartStringDouble({
    super.key, 
    required this.chartTitle, 
    required this.yAxisTitle,
    required this.yAxisNumberFormat
    });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> data = [
      {'model': 'ChatGPT', 'score': 0.82, 'color': Colors.blue},
      {'model': 'Gemini', 'score': 0.67, 'color': Colors.deepPurple},
    ];

    return SfCartesianChart(
      title: ChartTitle(text: chartTitle),
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: 1,
        numberFormat: yAxisNumberFormat, // NumberFormat.percentPattern(),
        interval: 0.2,
        title: AxisTitle(text: yAxisTitle),
      ),
      series: <CartesianSeries>[
        ColumnSeries<Map<String, dynamic>, String>(
          dataSource: data,
          xValueMapper: (Map<String, dynamic> datum, _) => datum['model'] as String,
          yValueMapper: (Map<String, dynamic> datum, _) => datum['score'] as double,
          pointColorMapper: (datum, _) => datum['color'] as Color,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          enableTooltip: true,
          name: 'Score',
        ),
      ],
    );
  }
}
