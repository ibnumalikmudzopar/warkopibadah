import 'dart:convert'; // Import library dart:convert untuk pengolahan JSON

// Fungsi untuk membuat objek Item dari JSON
Item itemFromJson(String str) => Item.fromJson(json.decode(str));

// Fungsi untuk mengubah objek Item menjadi JSON
String itemToJson(Item data) => json.encode(data.toJson());

// Kelas yang merepresentasikan sebuah barang (Item)
class Item {
    String id; // ID barang
    String name; // Nama barang
    String hargapcs; // Harga barang / pcs
    String hargapak; // Harga barang / pak
    String? kategori; // Kategori barang (opsional)
    String? modal; // Modal barang (opsional)
    String? userId; // User ID (opsional)

    // Konstruktor Item
    Item({
        required this.id,
        required this.name,
        required this.hargapcs,
        required this.hargapak,
        this.kategori,
        this.modal,
        this.userId,
    });

    // Factory method untuk membuat objek Item dari JSON
    factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        name: json["name"],
        hargapcs: json["hargapcs"],
        hargapak: json["hargapak"],
        kategori: json["kategori"], // Pastikan kategori opsional
        modal: json["modal"], // Pastikan modal opsional
        userId: json["userId"], // Pastikan userId opsional
    );

    // Method untuk mengubah objek Item menjadi JSON
    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "hargapcs": hargapcs,
        "hargapak": hargapak,
        "kategori": kategori ?? '', // Jika null, berikan default ''
        "modal": modal ?? '', // Jika null, berikan default ''
        "userId": userId ?? '', // Jika null, berikan default ''
    };
}
