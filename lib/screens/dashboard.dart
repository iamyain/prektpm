import 'package:cek_ongkir/screens/logout.dart';
import 'package:cek_ongkir/screens/ongkir.dart';
import 'package:cek_ongkir/screens/profile.dart';
import 'package:cek_ongkir/screens/saran.dart';
import 'package:cek_ongkir/services/apiservice.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../models/kota.dart';
import '../services/databasehelper.dart';
import 'detail.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  var kota_asal;
  var kota_tujuan;
  var berat;
  var kurir;
  var selectedIndex = 0;
  final apiService = ApiService();

  List<Kota> kotaList = [];

  final List<Widget> _pages = [
    OngkirPage(),
    SaranPage(),
    ProfilePage(),
    LogoutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
              label: 'Saran dan Kesan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              label: 'Profil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'Logout',
            )
          ],
          currentIndex: selectedIndex,
          onTap: (int index) {
            setState(() {
              selectedIndex = index;
            });
          }),
    );
  }
}
