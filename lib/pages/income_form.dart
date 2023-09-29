import 'package:cashbook/models/Finance.dart';
import 'package:cashbook/models/Users.dart';
import 'package:cashbook/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cashbook/helpers/db_helpers.dart';

class IncomeFormPage extends StatefulWidget {
  const IncomeFormPage({Key? key, required this.user}) : super(key: key);
  final Users user;

  @override
  State<IncomeFormPage> createState() => _IncomeFormPageState();
}

class _IncomeFormPageState extends State<IncomeFormPage> {
  TextEditingController dateController = TextEditingController();
  TextEditingController nominalController = TextEditingController();
  TextEditingController descController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
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
                child: Column(children: [
                  const Text(
                    "Tambah Pemasukan",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2020)),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Tanggal',
                      labelStyle: const TextStyle(color: Color(0xFF2C2020)),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF2C2020)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFFB03A)),
                      ),
                      errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF08658)),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () => _selectDate(context),
                        child: const Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: nominalController,
                    decoration: const InputDecoration(
                      labelText: 'Nominal',
                      labelStyle: TextStyle(color: Color(0xFF2C2020)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF2C2020)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFFB03A)),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF08658)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Keterangan',
                      labelStyle: TextStyle(color: Color(0xFF2C2020)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF2C2020)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFFB03A)),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF08658)),
                      ),
                    ),
                    controller: descController,
                    maxLines: 3,
                  ),
                ]))
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 181, 29, 29)),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.only(top: 20, bottom: 20))),
                child: const Text('Reset',
                    style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 242, 242, 242),
                        fontWeight: FontWeight.w500)),
                onPressed: () {
                  dateController.clear();
                  nominalController.clear();
                  descController.clear();
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 23, 154, 69)),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.only(top: 20, bottom: 20))),
                child: const Text('Simpan',
                    style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 242, 242, 242),
                        fontWeight: FontWeight.w500)),
                onPressed: () async {
                  final DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(dateController.text);
                  final double nominal = double.parse(nominalController.text);
                  final String desc = descController.text;

                  final Finance finance = Finance(
                    type:'income',
                    date: parsedDate,
                    nominal: nominal,
                    desc: desc,
                  );

                  try {
                    final dbHelper = DbHelper();
                    await dbHelper.insertFinance(finance);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashboardPage(user: widget.user),
                      ),
                    );
                  } catch (e) {
                    print("Error inserting finance data: $e");
                    // Handle the error as needed
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 88, 108, 240)),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.only(top: 20, bottom: 20))),
                child: const Text('Kembali',
                    style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 242, 242, 242),
                        fontWeight: FontWeight.w500)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DashboardPage(user: widget.user)));
                },
              ),
            ),
          ),
        ]));
  }
}
