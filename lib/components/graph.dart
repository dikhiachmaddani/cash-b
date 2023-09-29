import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Graph extends StatelessWidget {
  const Graph({
    Key? key,
    required this.incomeDataChart,
    required this.expenseDataChart,
  }) : super(key: key);

  final List<FlSpot> incomeDataChart;
  final List<FlSpot> expenseDataChart;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
              spots: incomeDataChart,
              isCurved: true,
              dotData: FlDotData(
                show: false,
              ),
              color: const Color.fromARGB(255, 23, 154, 69),
              ),
          LineChartBarData(
              spots: expenseDataChart,
              isCurved: true,
              dotData: FlDotData(
                show: false,
              ),
              color: const Color.fromARGB(255, 181, 29, 29)),
        ],
        borderData: FlBorderData(
            border: const Border(
                bottom: BorderSide(color: Color(0xFFFFB03A)),
                left: BorderSide(color: Color(0xFFFFB03A)))),
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(sideTitles: _bottomTitles),
          leftTitles: AxisTitles(sideTitles: _leftTitles),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
      ),
      swapAnimationDuration:const Duration(milliseconds: 250),
      swapAnimationCurve: Curves.linear,
    );
  }
  
  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 10,
        getTitlesWidget: (value, meta) {
          // Convert the value (which is in milliseconds since epoch) to a DateTime.
          final dateTime = DateTime.fromMillisecondsSinceEpoch(value.toInt());
          String month = "";
          switch (dateTime.month) {
            case 1:
              month = 'Jan';
              break;
            case 3:
              month = 'Mar';
              break;
            case 5:
              month = 'May';
              break;
            case 7:
              month = 'Jul';
              break;
            case 9:
              month = 'Sep';
              break;
            case 11:
              month = 'Nov';
              break;
          }
          return Text(
            '${dateTime.day} $month',
            style: const TextStyle(fontSize: 9, color: Color(0xFFFFB03A)),
          );
        },
      );

  SideTitles get _leftTitles => SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: (value, meta) {
          final currencyFormatter =
              NumberFormat.compactCurrency(locale: 'id_ID', symbol: '');
          return Text(
            currencyFormatter.format(value),
            style: const TextStyle(fontSize: 10, color: Color(0xFFFFB03A)),
          );
        },
      );
}