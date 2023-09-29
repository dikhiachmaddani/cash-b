import 'package:cashbook/helpers/db_helpers.dart';
import 'package:cashbook/models/Users.dart';
import 'package:cashbook/pages/dashboard.dart';
import 'package:cashbook/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key, required this.user}) : super(key: key);
  final Users user;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  DbHelper db = DbHelper();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  Future<void> changePassword() async {
    if (passwordController.text == widget.user.password) {
      await db.update(Users.fromMap({
        'id': widget.user.id,
        'username': widget.user.username,
        'password': newPasswordController.text,
      }));
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Login()));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Password Sudah di ganti, Silahkan login!'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Password salah, Silahkan coba lagi!'),
      ));
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
                    "Pengaturan",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2020)),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
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
                  const SizedBox(height: 40),
                  TextFormField(
                    obscureText: true,
                    controller: newPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'New Password',
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
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
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
                      onPressed: changePassword,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
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
                ]))
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ListTile(
                  contentPadding: const EdgeInsets.only(
                      top: 15, bottom: 15, left: 25, right: 25),
                  shape: BeveledRectangleBorder(
                    //<-- SEE HERE
                    side: const BorderSide(width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  tileColor: const Color(0xFFFFB03A),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                            "assets/foto.png"), // No matter how big it is, it won't overflow
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Text(
                            'About This App..',
                            style: TextStyle(
                                color: Color(0xFF2C2020),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Aplikasi Ini dibuat oleh:',
                            style: TextStyle(
                                color: Color(0xFF2C2020),
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'NIM: 2141764159',
                            style: TextStyle(
                                color: Color(0xFF2C2020),
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Tanggal: 24 September 2023',
                            style: TextStyle(
                                color: Color(0xFF2C2020),
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  ),
                )),
          ),
        ]));
  }
}
