import 'dart:developer';

import 'package:cashbook/helpers/db_helpers.dart';
import 'package:cashbook/models/Finance.dart';
import 'package:cashbook/models/Users.dart';
import 'package:cashbook/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailCashflowPage extends StatefulWidget {
  const DetailCashflowPage({Key? key, required this.user}) : super(key: key);
  final Users user;

  @override
  State<DetailCashflowPage> createState() => _DetailCashflowPageState();
}

class _DetailCashflowPageState extends State<DetailCashflowPage> {
  DbHelper db = DbHelper();
  List<Finance> financialData = [];

  @override
  void initState() {
    super.initState();
    _getAllFinance();
  }

  Future<void> _getAllFinance() async {
    var data = await db.getAllFinance();
    setState(() {
      financialData = data.map((row) => Finance.fromMap(row)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
        child: ListView(children: [
          const Text(
            "Detail Cash Flow",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C2020)),
          ),
          const SizedBox(height: 40),
          financialData.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: financialData.map((finance) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          tileColor: const Color(0xFF2C2020),
                          title: Text(
                            'Rp. ${finance.nominal}',
                            style: const TextStyle(
                              color: Color(0xFFFFB03A),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${finance.desc}',
                                style: const TextStyle(
                                  color: Color(0xFFFFB03A),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                finance.date != null
                                    ? DateFormat('yyyy-MM-dd')
                                        .format(finance.date!)
                                    : '-',
                                style: const TextStyle(
                                  color: Color(0xFFFFB03A),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          trailing: finance.type == 'income'
                              ? const Icon(
                                  Icons.arrow_back,
                                  color: Color(0xFF58F08C),
                                )
                              : finance.type == 'expense'
                                  ? const Icon(
                                      Icons.arrow_forward,
                                      color: Color.fromARGB(255, 181, 29, 29),
                                    )
                                  : const Text('')),
                    );
                  }).toList(),
                ),
        ]),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => DashboardPage(user: widget.user)));
          },
          backgroundColor: const Color(0xFF2C2020),
          child: const Icon(
            Icons.arrow_back,
            color: Color(0xFFFFB03A),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
