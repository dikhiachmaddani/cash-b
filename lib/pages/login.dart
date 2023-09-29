import 'package:cashbook/helpers/db_helpers.dart';
import 'package:cashbook/pages/dashboard.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  DbHelper db = DbHelper();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Center(
          child: Container(
              padding: const EdgeInsets.all(0.0),
              width: 375.0,
              height: 350.0,
              child: Column(
                children: [
                  const Image(
                      height: 100, image: AssetImage('assets/ic_launcher.png')),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 50, right: 50, top: 30),
                    child: TextField(
                      // controller: title,
                      textAlign: TextAlign.center,
                      controller: usernameController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        hintText: "username",
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Color(0xFF2C2020)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFFB03A)),
                        ),
                      ),
                      style: const TextStyle(
                          fontSize: 15, color: Color(0xFF2C2020)),
                      // initialValue: _title,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 50, right: 50, top: 15, bottom: 50),
                    child: TextField(
                      textAlign: TextAlign.center,
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        hintText: "password",
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Color(0xFF2C2020)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFFB03A)),
                        ),
                      ),
                      style: const TextStyle(
                          fontSize: 15, color: Color(0xFF2C2020)),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final username = usernameController.text;
                        final password = passwordController.text;

                        final user = await db.getUserByUsername(username);

                        if (user != null && user.password == password) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DashboardPage(user: user)));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Selamat Datang, ${user.username}!'),
                          ));
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Gagal Login, Silahkan Coba Lagi!'),
                          ));
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(
                            left: 30, right: 30, top: 15, bottom: 15),
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Color(0xFFFFB03A),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF2C2020)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(100))))),
                ],
              )),
        ),
      ),
    );
  }
}
