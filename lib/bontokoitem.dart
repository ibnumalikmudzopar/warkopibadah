import 'dart:convert'; // Import library dart:convert untuk pengolahan JSON

// Fungsi untuk membuat objek Item dari JSON
BonTokoItem itemFromJson(String str) => BonTokoItem.fromJson(json.decode(str));

// Fungsi untuk mengubah objek Item menjadi JSON
String itemToJson(BonTokoItem data) => json.encode(data.toJson());
// BonToko
// Kelas yang merepresentasikan sebuah barang (Item)
class BonTokoItem {
    String jumlah;
    String nama; // Nama barang
    String harga;  // Jenis barang (opsional)
    String lastupdate;

    // Konstruktor Item
    BonTokoItem({
        required this.jumlah, // ID wajib diisi
        required this.nama, // Nama wajib diisi
        required this.harga,
        required this.lastupdate,
    });

    // Factory method untuk membuat objek Item dari JSON
    factory BonTokoItem.fromJson(Map<String, dynamic> json) => BonTokoItem(
        jumlah: json["jumlah"],
        nama: json["nama"],
        harga: json["harga"],
        lastupdate: json["lastupdate"]
    );

    // Method untuk mengubah objek Item menjadi JSON
    Map<String, dynamic> toJson() => {
        "jumlah": jumlah,
        "nama": nama,
        "harga": harga,
        "lastupdate": lastupdate,
    };
}