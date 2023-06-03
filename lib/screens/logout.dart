import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  Future<void> clearSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Logout'),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              Text("Tekan tombol Logout untuk keluar dari aplikasi."),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    clearSharedPreferences().then((_) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    });
                  },
                  child: Text("Logout"))
            ],
          ),
        ));
  }
}
