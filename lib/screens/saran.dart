import 'package:flutter/material.dart';

class SaranPage extends StatelessWidget {
  const SaranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Saran dan Kesan'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Saran",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                      fontSize: 20),
                ),
                SizedBox(height: 10),
                Text("Kuisnya jangan susah susah ya pak 😂"),
                SizedBox(height: 40),
                Text(
                  "Kesan",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                      fontSize: 20),
                ),
                SizedBox(height: 10),
                Text("Pembelajarannya sangat menyenangkan")
              ],
            ),
          ),
        ));
  }
}
