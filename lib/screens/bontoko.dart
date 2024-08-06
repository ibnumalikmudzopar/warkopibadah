import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:warkopibadah/bontokoitem.dart';

class Bontoko extends StatefulWidget {
  const Bontoko({Key? key}) : super(key: key);

  @override
  _BontokoState createState() => _BontokoState();
}

class _BontokoState extends State<Bontoko> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'bontoko_items';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection(_collectionName).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading....');
            default:
              List<BonTokoItem> _bonTokoItems = snapshot.data!.docs.map((item) => BonTokoItem(
                jumlah: item['jumlah'].toString(),
                isi: item['isi'] ?? '',
                nama: item['nama'] ?? '',
                kategori: item['kategori'] ?? '',
                harga: item['harga'].toString(),
                lastupdate: DateFormat('dd/MM').format(item['lastupdate'].toDate()), // <--- updated
              )).toList();

              return CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Table(
                      border: TableBorder.all(color: Colors.transparent),
                      columnWidths: {
                        0: FlexColumnWidth(0.5), // No column
                        1: FlexColumnWidth(1.1), // Jumlah column
                        2: FlexColumnWidth(0.5), // Isi column
                        3: FlexColumnWidth(2.0), // Nama column
                        4: FlexColumnWidth(1.5), // Harga column
                        5: FlexColumnWidth(0.8), // Harga column
                      },
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Text('No'),
                            ),
                            TableCell(
                              child: Text('Jumlah'),
                            ),
                            TableCell(
                              child: Text('Isi'),
                            ),
                            TableCell(
                              child: Text('Nama'),
                            ),
                            TableCell(
                              child: Text('Harga'),
                            ),
                            TableCell(
                              child: Row(
                                children: [
                                  Icon(Icons.update),
                                ],
                              ),
                            ),
                          ],
                        ),
                        ..._bonTokoItems.map((item) {
                          return TableRow(
                            children: [
                              TableCell(
                                child: Text((_bonTokoItems.indexOf(item) + 1).toString()),
                              ),
                              TableCell(
                                child: Text(item.jumlah),
                              ),
                              TableCell(
                                child: Text(item.isi),
                              ),
                              TableCell(
                                child: Text(item.nama),
                              ),
                              TableCell(
                                child: Text(item.harga),
                              ),
                              TableCell(
                                child: Row(
                                  children: [
                                    Text(item.lastupdate),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  bool isNumeric(String s) {
    return s.isNotEmpty && double.tryParse(s) != null;
  }

showAddDialog() {
  var jumlahController = TextEditingController();
  var isiController = TextEditingController();
  var namaController = TextEditingController();
  var hargaController = TextEditingController();

  var _currencies = [
    "Rokok",
    "Makanan",
    "Minuman",
    "Pindang",
    "ATK",
    "Plastik",
    "Lainnya",
  ];

  String _currentSelectedKategori = _currencies[0]; // Inisialisasi dengan nilai pertama

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                 Center(
                  child: const Text('Detail Barang', style: TextStyle(fontSize: 20)),),
                  const SizedBox(height: 20),
                  TextField(
                    controller: jumlahController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      labelText: 'Jumlah',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: isiController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0), 
                      ),
                      labelText: 'isi',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: namaController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      labelText: 'nama',
                    ),
                  ),
                  const SizedBox(height: 10),
                  FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Pilih Kategori',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        isEmpty: _currentSelectedKategori == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _currentSelectedKategori,
                            isDense: true,
                            onChanged: (String? newValue) {
                              setState(() {
                                _currentSelectedKategori = newValue ?? _currencies[0]; // Handle nullable value
                                state.didChange(newValue);
                              });
                            },
                            items: _currencies.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: hargaController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      labelText: 'Harga',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Implementasi logika tambah barang disini
                      var jumlah = jumlahController.text.trim();
                      var isi = isiController.text.trim();
                      var nama = namaController.text.trim();
                      var kategori = _currentSelectedKategori;
                      var harga = hargaController.text.trim();
                      var lastupdate = DateTime.now();
                      addItem(jumlah, isi, nama, harga, kategori, lastupdate as String);
                      Navigator.of(context).pop(); // Tutup dialog setelah tambah barang
                    },
                    child: const Text('Simpan'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
  }
  // Metode untuk menambahkan barang baru ke Firestore
  addItem(String jumlah, String isi, String nama, String harga, String kategori, String lastupdate) {
    var item = BonTokoItem(jumlah: jumlah, isi: isi, nama: nama, harga: harga, kategori: kategori, lastupdate: lastupdate);
    FirebaseFirestore.instance.collection(_collectionName).add(item.toJson());
  }
}
