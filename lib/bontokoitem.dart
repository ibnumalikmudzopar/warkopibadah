import 'dart:convert'; // Import library dart:convert untuk pengolahan JSON

// Fungsi untuk membuat objek Item dari JSON
BonTokoItem itemFromJson(String str) => BonTokoItem.fromJson(json.decode(str));

// Fungsi untuk mengubah objek Item menjadi JSON
String itemToJson(BonTokoItem data) => json.encode(data.toJson());

// BonToko
// Kelas yang merepresentasikan sebuah barang (Item)
class BonTokoItem {
  String jumlah;
  String isi;
  String nama; // Nama barang
  String harga;  // Harga barang
  String kategori; // Kategori barang
  String lastupdate; // Waktu terakhir diupdate

  BonTokoItem({
    required this.jumlah,
    required this.isi,
    required this.nama,
    required this.harga,
    required this.kategori,
    required this.lastupdate,
  });

  // Membuat objek Item dari JSON
  factory BonTokoItem.fromJson(Map<String, dynamic> json) => BonTokoItem(
        jumlah: json["jumlah"],
        isi: json["isi"],
        nama: json["nama"],
        harga: json["harga"],
        kategori: json["kategori"],
        lastupdate: json["lastupdate"],
      );

  // Mengubah objek Item menjadi JSON
  Map<String, dynamic> toJson() => {
        "jumlah": jumlah,
        "isi": isi,
        "nama": nama,
        "harga": harga,
        "kategori": kategori,
        "lastupdate": lastupdate,
      };
}
