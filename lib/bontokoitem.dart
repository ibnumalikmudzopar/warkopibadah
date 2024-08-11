import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// Fungsi untuk membuat objek Item dari JSON
BonTokoItem itemFromJson(String str) => BonTokoItem.fromJson(json.decode(str));

// Fungsi untuk mengubah objek Item menjadi JSON
String itemToJson(BonTokoItem data) => json.encode(data.toJson());

// BonToko
// Kelas yang merepresentasikan sebuah barang (Item)
class BonTokoItem {
  String id; // Menambahkan id
  String jumlah;
  String isi;
  String nama;
  String kategori;
  String harga;
  DateTime lastupdate;

  BonTokoItem({
    required this.id,
    required this.jumlah,
    required this.isi,
    required this.nama,
    required this.kategori,
    required this.harga,
    required this.lastupdate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Menambahkan id ke JSON
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
      id: json['id'], // Menambahkan id dari JSON
      jumlah: json['jumlah'],
      isi: json['isi'],
      nama: json['nama'],
      kategori: json['kategori'],
      harga: json['harga'],
      lastupdate: (json['lastupdate'] as Timestamp).toDate(), // Ubah dari Timestamp ke DateTime
    );
  }
}
