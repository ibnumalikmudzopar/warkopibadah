import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:warkopibadah/bontokoitem.dart';

class Bontoko extends StatefulWidget {
  const Bontoko({Key? key}) : super(key: key);

  @override
  _BontokoState createState() => _BontokoState();
}

class _BontokoState extends State<Bontoko> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'bontoko_items';

  DateTime parseTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp == null) {
      return DateTime.now(); // Atur default jika timestamp null
    } else {
      throw ArgumentError('Invalid timestamp');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection(_collectionName).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data found'));
          }

          List<BonTokoItem> _bonTokoItems = snapshot.data!.docs.map((item) {
            return BonTokoItem(
              id: item.id,
              jumlah: item['jumlah']?.toString() ?? '0',
              isi: item['isi'] ?? '',
              nama: item['nama'] ?? '',
              kategori: item['kategori'] ?? '',
              harga: item['harga']?.toString() ?? '0',
              lastupdate: parseTimestamp(item['lastupdate']),
            );
          }).toList();

          return CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Table(
                  border: TableBorder.all(color: Colors.transparent),
                  columnWidths: const {
                    0: FlexColumnWidth(0.5),
                    1: FlexColumnWidth(1.1),
                    2: FlexColumnWidth(0.5),
                    3: FlexColumnWidth(2.0),
                    4: FlexColumnWidth(1.5),
                    5: FlexColumnWidth(0.8),
                  },
                  children: [
                    const TableRow(
                      children: [
                        TableCell(child: Text('No')),
                        TableCell(child: Text('Jumlah')),
                        TableCell(child: Text('Isi')),
                        TableCell(child: Text('Nama')),
                        TableCell(child: Text('Harga')),
                        TableCell(child: Text('Time')),
                      ],
                    ),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final item = _bonTokoItems[index];
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              _showDeleteConfirmationDialog(item);
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            spacing: 8,
                          ),
                          SlidableAction(
                            onPressed: (context) {
                              showUpdateDialog(item.id, item.jumlah, item.isi, item.nama, item.harga, item.kategori);
                            },
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            spacing: 8,
                          ),
                        ],
                      ),
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(0.5),
                          1: FlexColumnWidth(1.1),
                          2: FlexColumnWidth(0.5),
                          3: FlexColumnWidth(2.0),
                          4: FlexColumnWidth(1.5),
                          5: FlexColumnWidth(0.8),
                        },
                        border: TableBorder.all(color: Colors.transparent),
                        children: [
                          TableRow(
                            children: [
                              TableCell(child: Text((index + 1).toString())),
                              TableCell(child: Text(item.jumlah)),
                              TableCell(child: Text(item.isi)),
                              TableCell(child: Text(item.nama)),
                              TableCell(child: Text(item.harga)),
                              TableCell(child: Text(DateFormat('yyyy-MM-dd').format(item.lastupdate))),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: _bonTokoItems.length,
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  void _showDeleteConfirmationDialog(BonTokoItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hapus ${item.nama}?'),
          content: Text('Anda yakin ingin menghapus item ini?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                deleteItem(item.id);
                Navigator.of(context).pop();
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void showAddDialog() {
    var jumlahController = TextEditingController();
    var isiController = TextEditingController();
    var namaController = TextEditingController();
    var hargaController = TextEditingController();

    List<String> _currencies = [
      "Rokok",
      "Makanan",
      "Minuman",
      "Pindang",
      "ATK",
      "Plastik",
      "Lainnya",
    ];

    String _currentSelectedKategori = _currencies.isNotEmpty ? _currencies[0] : '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Detail Barang'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: jumlahController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      labelText: 'Jumlah',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: isiController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      labelText: 'Isi',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: namaController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      labelText: 'Nama',
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _currentSelectedKategori,
                    onChanged: (String? newValue) {
                      setState(() {
                        _currentSelectedKategori = newValue ?? _currencies[0];
                      });
                    },
                    items: _currencies.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      labelText: 'Pilih Kategori',
                    ),
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
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (jumlahController.text.isEmpty || namaController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Jumlah dan Nama harus diisi')),
                      );
                      return;
                    }
                    var jumlah = jumlahController.text.trim();
                    var isi = isiController.text.trim();
                    var nama = namaController.text.trim();
                    var kategori = _currentSelectedKategori;
                    var harga = hargaController.text.trim();
                    var lastupdate = DateTime.now();
                    addItem(jumlah, isi, nama, harga, kategori, lastupdate);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Simpan'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Batal'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> addItem(String jumlah, String isi, String nama, String harga, String kategori, DateTime lastupdate) async {
    try {
      await _firestore.collection(_collectionName).add({
        'jumlah': jumlah,
        'isi': isi,
        'nama': nama,
        'kategori': kategori,
        'harga': harga,
        'lastupdate': Timestamp.fromDate(lastupdate),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan item: $e')),
      );
    }
  }

  void showUpdateDialog(String id, String jumlah, String isi, String nama, String harga, String kategori) {
    var jumlahController = TextEditingController(text: jumlah);
    var isiController = TextEditingController(text: isi);
    var namaController = TextEditingController(text: nama);
    var hargaController = TextEditingController(text: harga);

    List<String> _currencies = [
      "Rokok",
      "Makanan",
      "Minuman",
      "Pindang",
      "ATK",
      "Plastik",
      "Lainnya",
    ];

    String _currentSelectedKategori = _currencies.contains(kategori) ? kategori : _currencies[0];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Update Barang'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: jumlahController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      labelText: 'Jumlah',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: isiController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      labelText: 'Isi',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: namaController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      labelText: 'Nama',
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _currentSelectedKategori,
                    onChanged: (String? newValue) {
                      setState(() {
                        _currentSelectedKategori = newValue ?? _currencies[0];
                      });
                    },
                    items: _currencies.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      labelText: 'Pilih Kategori',
                    ),
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
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (jumlahController.text.isEmpty || namaController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Jumlah dan Nama harus diisi')),
                      );
                      return;
                    }
                    var jumlah = jumlahController.text.trim();
                    var isi = isiController.text.trim();
                    var nama = namaController.text.trim();
                    var kategori = _currentSelectedKategori;
                    var harga = hargaController.text.trim();
                    updateItem(id, jumlah, isi, nama, harga, kategori);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Update'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Batal'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> updateItem(String id, String jumlah, String isi, String nama, String harga, String kategori) async {
    try {
      await _firestore.collection(_collectionName).doc(id).update({
        'jumlah': jumlah,
        'isi': isi,
        'nama': nama,
        'kategori': kategori,
        'harga': harga,
        'lastupdate': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui item: $e')),
      );
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      await _firestore.collection(_collectionName).doc(id).delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus item: $e')),
      );
    }
  }
}