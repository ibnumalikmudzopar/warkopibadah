import 'dart:convert'; // Import library dart:convert untuk pengolahan JSON

// Fungsi untuk membuat objek Item dari JSON
Item itemFromJson(String str) => Item.fromJson(json.decode(str));

// Fungsi untuk mengubah objek Item menjadi JSON
String itemToJson(Item data) => json.encode(data.toJson());

// Kelas yang merepresentasikan sebuah barang (Item)
class Item {
    String id; // ID barang
    String name; // Nama barang
    String hargapcs; // Harga barang
    String hargapak; // Harga barang
    String? kategori; // Jenis barang (opsional)
    String? modal; // Jenis barang (opsional)

    // Konstruktor Item
    Item({
        required this.id, // ID wajib diisi
        required this.name, // Nama wajib diisi
        required this.hargapcs, // Harga wajib diisi
        required this.hargapak,
        this.kategori, // Jenis boleh kosong
        this.modal, // Jenis boleh kosong
    });

    // Factory method untuk membuat objek Item dari JSON
    factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        name: json["name"],
        kategori: json["kategori"],
        hargapcs: json["hargapcs"],
        hargapak: json["hargapak"],
        modal: json["modal"],
    );

    // Method untuk mengubah objek Item menjadi JSON
    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "kategori": kategori,
        "hargapcs": hargapcs,
        "hargapak": hargapak,
        "modal": modal,
    };
}