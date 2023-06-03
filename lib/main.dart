import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cek_ongkir/screens/login.dart';
import 'package:cek_ongkir/screens/dashboard.dart';


void main() {
  initializeDateFormatting('id', null).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoggedIn(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Cek Ongkir',
              theme: ThemeData(
                primarySwatch: Colors.purple,
              ),
              home: DashboardPage(),
            );
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Cek Ongkir',
              theme: ThemeData(
                primarySwatch: Colors.purple,
              ),
              home: LoginPage(),
            );
          }
        } else {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }

  Future<bool> _checkLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    return email != null && password != null;
  }
}
