import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart'; // Import library dart:convert untuk pengolahan JSON

// Fungsi untuk membuat objek Item dari JSON
BonTokoItem itemFromJson(String str) => BonTokoItem.fromJson(json.decode(str));

// Fungsi untuk mengubah objek Item menjadi JSON
String itemToJson(BonTokoItem data) => json.encode(data.toJson());

// BonToko
// Kelas yang merepresentasikan sebuah barang (Item)
class BonTokoItem {
  String jumlah;
  String isi;
  String nama;
  String kategori;
  String harga;
  DateTime lastupdate;

  BonTokoItem({
    required this.jumlah,
    required this.isi,
    required this.nama,
    required this.kategori,
    required this.harga,
    required this.lastupdate,
  });

  Map<String, dynamic> toJson() {
    return {
      'jumlah': jumlah,
      'isi': isi,
      'nama': nama,
      'kategori': kategori,
      'harga': harga,
      'lastupdate': Timestamp.fromDate(lastupdate), // Simpan sebagai Timestamp
    };
  }

  factory BonTokoItem.fromJson(Map<String, dynamic> json) {
    return BonTokoItem(
      jumlah: json['jumlah'],
      isi: json['isi'],
      nama: json['nama'],
      kategori: json['kategori'],
      harga: json['harga'],
      lastupdate: (json['lastupdate'] as Timestamp).toDate(), // Ubah dari Timestamp ke DateTime
    );
  }
}
