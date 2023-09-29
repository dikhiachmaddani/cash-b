import 'package:cashbook/helpers/db_helpers.dart';
import 'package:cashbook/models/Users.dart';
import 'package:cashbook/pages/expense_form.dart';
import 'package:cashbook/pages/income_form.dart';
import 'package:cashbook/pages/setting.dart';
import 'package:cashbook/pages/detail_cashflow.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key, required this.user}) : super(key: key);
  final Users user;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final dbHelper = DbHelper();
  List<FlSpot> incomeDataChart = [];
  List<FlSpot> expenseDataChart = [];

  double totalIncome = 0.0;
  double totalExpense = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchIncomeChart();
    _fetchexpenseChart();
    _fetchTotalIncome();
    _fetchTotalExpense();
  }

  Future<void> _fetchTotalIncome() async {
    final income = await dbHelper.getTotalIncome();
    setState(() {
      totalIncome = income;
    });
  }

  Future<void> _fetchTotalExpense() async {
    final expense = await dbHelper.getTotalExpense();
    setState(() {
      totalExpense = expense;
    });
  }

  Future<void> _fetchIncomeChart() async {
    final getIncomeDataChart = await dbHelper.getIncomeDataForChart();
    setState(() {
      incomeDataChart = getIncomeDataChart;
    });
  }
  
  Future<void> _fetchexpenseChart() async {
    final getexpenseDataChart = await dbHelper.getExpenseDataForChart();
    setState(() {
      expenseDataChart = getexpenseDataChart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: ListView(
        children: [
          Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                  top: 50, left: 20, right: 20, bottom: 20),
              child: Column(
                children: [
                  const Text(
                    "Rangkuman Bulan Ini",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2020)),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF2C2020),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.only(
                        left: 20, right: 40, top: 30, bottom: 30),
                    child: AspectRatio(
                      aspectRatio: 2,
                      child: LineChart(
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
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      tileColor: const Color.fromARGB(255, 23, 154, 69),
                      title: const Text(
                        "Pemasukan:",
                        style: TextStyle(
                            color: Color.fromARGB(255, 247, 247, 247),
                            fontWeight: FontWeight.w500),
                      ),
                      trailing: Text(
                        'Rp. ${totalIncome.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 247, 247, 247),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      tileColor: const Color.fromARGB(255, 181, 29, 29),
                      title: const Text(
                        "Pengeluaran:",
                        style: TextStyle(
                            color: Color.fromARGB(255, 247, 247, 247),
                            fontWeight: FontWeight.w500),
                      ),
                      trailing: Text('Rp. ${totalExpense.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 247, 247, 247),
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              IconButton(
                                icon: Image.asset('assets/add.png'),
                                iconSize: 75,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => IncomeFormPage(
                                              user: widget.user)));
                                },
                              ),
                              const Text(
                                "Tambah Pemasukan",
                                style: TextStyle(
                                    color: Color(0xFF2C2020),
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 15),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              IconButton(
                                icon: Image.asset('assets/minus.png'),
                                iconSize: 75,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ExpenseFormPage(
                                              user: widget.user)));
                                },
                              ),
                              const Text(
                                "Tambah Pengeluaran",
                                style: TextStyle(
                                    color: Color(0xFF2C2020),
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 15),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              IconButton(
                                icon: Image.asset('assets/detail.png'),
                                iconSize: 75,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailCashflowPage(
                                                  user: widget.user)));
                                },
                              ),
                              const Text(
                                "Detail Cashflow",
                                style: TextStyle(
                                    color: Color(0xFF2C2020),
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Column(
                            children: [
                              IconButton(
                                icon: Image.asset('assets/setting.png'),
                                iconSize: 75,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SettingPage(user: widget.user)));
                                },
                              ),
                              const Text(
                                "Pengaturan",
                                style: TextStyle(
                                    color: Color(0xFF2C2020),
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ))
        ],
      ),
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
