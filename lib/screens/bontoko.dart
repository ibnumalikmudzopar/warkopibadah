import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warkopibadah/bontokoitem.dart';

class Bontoko extends StatefulWidget {
  const Bontoko({Key? key}) : super(key: key);

  @override
  _BontokoState createState() => _BontokoState();
}

class _BontokoState extends State<Bontoko> {
  List<BonTokoItem> _bonTokoItems = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'bontoko_items';
  final _formKey = GlobalKey<FormState>();
  String _nama = '';
  String _jumlah = ''; // Ubah tipe data menjadi String
  int _harga = 0;

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  Future<void> _fetchRecords() async {
    try {
      final records = await _firestore.collection(_collectionName).get();
      _mapRecords(records);
    } catch (e) {
      print('Error fetching records: $e');
    }
  }

  void _mapRecords(QuerySnapshot<Map<String, dynamic>> records) {
    final _list = records.docs.map(
      (item) => BonTokoItem(
        nama: item['nama'],
        jumlah: item['jumlah'].toString(),
        harga: item['harga'],
        lastupdate: item['lastupdate'].toDate().toString(), // Convert Timestamp to String
      ),
    ).toList();

    setState(() {
      _bonTokoItems = _list;
    });
  }

  void _addRecord() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _firestore.collection(_collectionName).add({
          'nama': _nama,
          'jumlah': _jumlah, // Simpan sebagai String
          'harga': _harga,
          'lastupdate': FieldValue.serverTimestamp(),
        });
        _fetchRecords();
      } catch (e) {
        print('Error adding record: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bontoko'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Jumlah',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Jumlah tidak boleh kosong';
                      }
                      return null;
                    },
                    onSaved: (value) => _jumlah = value!, // Simpan sebagai String
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nama',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      return null;
                    },
                    onSaved: (value) => _nama = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Harga',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Harga tidak boleh kosong';
                      }
                      if (!isNumeric(value)) {
                        return 'Harga harus berupa angka';
                      }
                      return null;
                    },
                    onSaved: (value) => _harga = int.parse(value!),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addRecord,
                    child: Text('Tambah'),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Table(
              border: TableBorder.all(),
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
                      child: Text('Nama'),
                    ),
                    TableCell(
                      child: Text('Harga'),
                    ),
                  ],
                ),
                ..._bonTokoItems.map((item) {
                  return TableRow(
                    children: [
                      TableCell(
                        child: Text(_bonTokoItems.indexOf(item).toString()),
                      ),
                      TableCell(
                        child: Text(item.jumlah), // Tampilkan sebagai String
                      ),
                      TableCell(
                        child: Text(item.nama),
                      ),
                      TableCell(
                        child: Text(item.harga.toString()),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool isNumeric(String s) {
    return s.isNotEmpty && double.tryParse(s) != null;
  }
}