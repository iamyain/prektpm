import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/apiservice.dart';

class DetailPage extends StatefulWidget {
  final String? kota_asal;
  final String? kota_tujuan;
  final String? berat;
  final String? kurir;
  final String? uang;

  DetailPage(
      {this.kota_asal, this.kota_tujuan, this.berat, this.kurir, this.uang});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List _data = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // panggil API utk menghitung ongkir berdasarkan data yang dibawa dari halaman sebelumnya.
    _getData();
  }

  Future<void> _getData() async {
    try {
      final List<dynamic> data = await ApiService.getCost(
        widget.kota_asal!,
        widget.kota_tujuan!,
        int.parse(widget.berat!),
        widget.kurir!,
      );
      //hasil perhitungan ongkir akan disimpan di state _data dan akan ditampilkan di UI Listview
      setState(() {
        _data = data;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      _isLoading = false;
    }
  }

  String formatCurrency(int value) {
    //digunakan utk mengkonversi nilai mata uang berdasarkan pilihan di halaman sebelum nya.
    final mataUang = widget.uang!;
    double nilai = value.toDouble();
    if (mataUang == 'USD') {
      nilai = value * 0.000067;
    } else if (mataUang == 'SGD') {
      nilai = value * 0.000090;
    } else if (mataUang == 'JPY') {
      nilai = value * 0.0092;
    }
    final format = NumberFormat('#,###.00', 'id');
    return format.format(nilai);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Cek Ongkir"),
      ),
      body: _isLoading
          ? Center(
              child:
                  CircularProgressIndicator(), // Show CircularProgressIndicator if still loading
            )
          : ListView.builder(
              itemCount: _data.length,
              itemBuilder: (_, index) {
                final int costValue = _data[index]['cost'][0]['value'] as int;
                final String formattedValue = formatCurrency(costValue);
                return ListTile(
                  title: Text(
                    "${_data[index]['service']}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.purple),
                  ),
                  subtitle: Text("${_data[index]['description']}"),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${widget.uang!} $formattedValue',
                        style: TextStyle(fontSize: 20, color: Colors.purple),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text("${_data[index]['cost'][0]['etd']} hari")
                    ],
                  ),
                );
              },
            ),
    );
  }
}
