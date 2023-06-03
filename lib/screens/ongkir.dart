import 'package:cek_ongkir/screens/profile.dart';
import 'package:cek_ongkir/screens/saran.dart';
import 'package:cek_ongkir/services/apiservice.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/kota.dart';
import '../services/databasehelper.dart';
import 'detail.dart';

class OngkirPage extends StatefulWidget {
  const OngkirPage({super.key});

  @override
  State<OngkirPage> createState() => _OngkirPageState();
}

class _OngkirPageState extends State<OngkirPage> {
  var kota_asal;
  var kota_tujuan;
  var berat;
  var kurir;
  var uang;
  var zonawaktu;
  final apiService = ApiService();

  List<Kota> kotaList = [];
  String _currentDateTime = '';

  @override
  void initState() {
    super.initState();
    _getCurrentDateTime('WIB');
  }

  void _getCurrentDateTime(String zona) {
    //Fungsi utk mengubah waktu berdasarkan zona

    var dateTimeNow = DateTime.now();
    if (zona == 'WITA') {
      dateTimeNow = DateTime.now().add(Duration(hours: 1));
    } else if (zona == 'WIT') {
      dateTimeNow = DateTime.now().add(Duration(hours: 2));
    } else if (zona == 'LONDON') {
      dateTimeNow = DateTime.now().subtract(Duration(hours: 6));
    }
    final formatter = DateFormat('dd MMMM yyyy, HH:mm:ss', 'id_ID');
    final formattedDateTime = formatter.format(dateTimeNow);
    setState(() {
      _currentDateTime = formattedDateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  DropdownSearch<String>(
                      mode: Mode.MENU,
                      selectedItem: "WIB",
                      showSelectedItems: true,
                      items: ["WIB", "WITA", "WIT", "LONDON"],
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Zona Waktu",
                        hintText: "Zona Waktu",
                      ),
                      onChanged: (text) {
                        _getCurrentDateTime(text!);
                      }),
                  SizedBox(height: 10),
                  Text(
                    _currentDateTime,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 40),
              const Text(
                "CEK ONGKIR",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              DropdownSearch<Kota>(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Kota Asal",
                  hintText: "Pilih Kota Asal",
                ),
                mode: Mode.BOTTOM_SHEET,
                showSearchBox: true,
                onChanged: (value) {
                  kota_asal = value?.cityId;
                },
                itemAsString: (item) => "${item!.type} ${item.cityName}",
                onFind: (text) async {
                  final data = await ApiService
                      .getAllCity(); // panggil API getAllCity yang sudah dibuat di apiservice.dart
                  kotaList = data.map((city) => Kota.fromJson(city)).toList();
                  return kotaList;
                },
              ),
              SizedBox(height: 20),
              DropdownSearch<Kota>(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Kota Tujuan",
                  hintText: "Pilih Kota Tujuan",
                ),

                //tersedia mode menu dan mode dialog
                mode: Mode.BOTTOM_SHEET,

                // menampilkan pencarian
                showSearchBox: true,

                //di dalam onchange bisa set state
                onChanged: (value) {
                  kota_tujuan = value?.cityId;
                },

                //kata yang akan ditampilkan setelah dipilih
                itemAsString: (item) => "${item!.type} ${item.cityName}",

                onFind: (text) async {
                  final data = await ApiService
                      .getAllCity(); // panggil API getAllCity yang sudah dibuat di apiservice.dart
                  kotaList = data.map((city) => Kota.fromJson(city)).toList();
                  return kotaList;
                },
              ),
              SizedBox(height: 20),
              TextField(
                //input hanya angka
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Berat Paket (gram)",
                  hintText: "Input Berat Paket",
                ),
                onChanged: (text) {
                  berat = text;
                },
              ),
              SizedBox(height: 20),
              DropdownSearch<String>(
                  mode: Mode.MENU,
                  showSelectedItems: true,
                  //pilihan kurir
                  items: ["jne", "tiki", "pos"],
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Kurir",
                    hintText: "Kurir",
                  ),
                  popupItemDisabled: (String s) => s.startsWith('I'),
                  onChanged: (text) {
                    kurir = text;
                  }),
              SizedBox(
                height: 20,
              ),
              DropdownSearch<String>(
                  mode: Mode.MENU,
                  showSelectedItems: true,
                  //pilihan mata uang
                  items: ["IDR", "USD", "SGD", "JPY"],
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Mata Uang",
                    hintText: "Mata Uang",
                  ),
                  onChanged: (text) {
                    uang = text;
                  }),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  //validasi
                  if (kota_asal == '' ||
                      kota_tujuan == '' ||
                      berat == '' ||
                      kurir == '' ||
                      uang == '') {
                    final snackBar = SnackBar(
                        content: Text("Isi bidang yang masih kosong!"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    //berpindah halaman dan bawa data
                    Navigator.push(
                      context,
                      // DetailPage adalah halaman yang dituju
                      MaterialPageRoute(
                          builder: (context) => DetailPage(
                              kota_asal: kota_asal,
                              kota_tujuan: kota_tujuan,
                              berat: berat,
                              kurir: kurir,
                              uang: uang)),
                    );
                  }
                },
                child: Center(
                  child: Text("Cek Ongkir"),
                ),
              )
            ],
          )),
    );
  }
}
