import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

// Nama koleksi Firestore yang digunakan untuk menyimpan barang_items
const COLLECTION_NAME = 'barang_items';

class BelanjaScreen extends StatefulWidget {
  BelanjaScreen({Key? key}) : super(key: key);

  @override
  _BelanjaScreenState createState() => _BelanjaScreenState();
}

class _BelanjaScreenState extends State<BelanjaScreen> {
  // Hari-hari dalam seminggu yang ditampilkan di grid kalender
  final List<String> daysOfWeek = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
  bool showForm = false; // Status untuk menunjukkan atau menyembunyikan form penambahan barang belanja
  final _formKey = GlobalKey<FormState>(); // GlobalKey untuk mengakses form secara global
  String _namaBelanja = ''; // Variabel untuk menyimpan nama barang belanja dari input pengguna
  int _jumlah = 0; // Variabel untuk menyimpan jumlah barang belanja dari input pengguna
  List<Map<String, dynamic>> _belanjaList = []; // List untuk menyimpan daftar barang belanja yang akan ditampilkan di DataTable
  List<String> _namaBarang = []; // List untuk menyimpan nama barang dari Firestore untuk saran autocomplete
  final TextEditingController searchNamaBarangController = TextEditingController(); // Controller untuk field pencarian nama barang

  @override
  void initState() {
    super.initState();
    // Panggil fetchRecords() saat initState() dipanggil untuk mengambil data barang dari Firestore
    fetchRecords();
    // Langganan perubahan data dari Firestore menggunakan snapshots()
    FirebaseFirestore.instance.collection(COLLECTION_NAME).snapshots().listen((records) {
      mapRecords(records); // Panggil fungsi mapRecords() untuk memetakan data Firestore ke dalam _namaBarang
    });
  }

  // Fungsi untuk mengambil data barang dari Firestore
  fetchRecords() async {
    var records = await FirebaseFirestore.instance.collection(COLLECTION_NAME).get();
    mapRecords(records); // Panggil fungsi mapRecords() untuk memetakan data Firestore ke dalam _namaBarang
  }

  // Fungsi untuk memetakan data dari Firestore ke dalam _namaBarang
  mapRecords(QuerySnapshot<Map<String, dynamic>> records) {
    var _list = records.docs.map((item) => item['name'] as String).toList();
    setState(() {
      _namaBarang = _list; // Perbarui _namaBarang dengan data yang diambil dari Firestore
    });
  }

  // Fungsi untuk memberikan saran nama barang berdasarkan query pencarian
  List<String> suggestions(String query) {
    return _namaBarang.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String monthName = DateFormat.yMMMM().format(now); // Format bulan dan tahun saat ini
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1); // Tanggal pertama dalam bulan saat ini
    int startWeekday = firstDayOfMonth.weekday % 7; // Hari dalam seminggu saat bulan dimulai

    return Scaffold(
      body: showForm
          ? SingleChildScrollView(
              child: _buildForm(), // Tampilkan form jika showForm true
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    monthName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: daysOfWeek.map((day) => Expanded(
                          child: Center(
                            child: Text(day, style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        )).toList(),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                      ),
                      itemCount: daysInMonth(now) + startWeekday,
                      itemBuilder: (context, index) {
                        if (index < startWeekday) {
                          return Center(
                            child: Text(''),
                          );
                        }
                        DateTime date = DateTime(now.year, now.month, index - startWeekday + 1);
                        bool isToday = date.day == now.day && date.month == now.month && date.year == now.year;
                        return Center(
                          child: Text(
                            DateFormat.d().format(date),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                              color: isToday ? Colors.red : Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showForm = true; // Tampilkan form saat tombol add ditekan
                        });
                      },
                      child: Icon(Icons.add),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  // Widget untuk membangun form penambahan barang belanja
  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            height: 300,
            width: 500,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Nama Barang')), // Kolom untuk nama barang
                  DataColumn(label: Text('Jumlah')), // Kolom untuk jumlah barang
                ],
                rows: _belanjaList
                    .map(
                      (belanja) => DataRow(
                        cells: [
                          DataCell(Text(belanja['nama'])), // Sel untuk nama barang
                          DataCell(Text(belanja['jumlah'].toString())), // Sel untuk jumlah barang
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(onPressed: () {
                setState(() {
                  _belanjaList.clear(); // Tombol untuk menghapus semua item dari _belanjaList
                });
              }, child: Text("Reset")),
              ElevatedButton(
                onPressed: () {
                  submitToFirebase(); // Tombol untuk mengirim data barang belanja ke Firebase
                },
                child: Text('Submit to Firebase'),
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: _showAddBarangDialog, // Tombol untuk menampilkan dialog penambahan barang belanja
                  child: Text("Tambah")),
              ElevatedButton(onPressed: () {
                setState(() {
                  showForm = false; // Tombol untuk kembali ke tampilan utama dari form
                });
              }, child: Text("Kembali"))
            ],
          )
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan dialog penambahan barang belanja
  void _showAddBarangDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Belanja'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TextFormField(
                //   controller: searchNamaBarangController,
                //   decoration: InputDecoration(
                //     labelText: 'Nama Belanja',
                //     border: OutlineInputBorder(),
                //   ),
                //   onChanged: (value) {
                //     setState(() {});
                //   },
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter nama belanja';
                //     }
                //     return null;
                //   },
                // ),
                SizedBox(height: 10),
                // TypeAheadField untuk memberikan saran nama barang berdasarkan input pengguna
                TypeAheadField(
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion.toString()),
                    );
                  },
                  onSelected: (suggestion) {
                    setState(() {
                      _namaBelanja = suggestion.toString(); // Update _namaBelanja dengan pilihan pengguna
                      searchNamaBarangController.text = suggestion.toString(); // Update controller untuk field pencarian
                    });
                  },
                  suggestionsCallback: (pattern) async {
                    // Callback untuk mengambil saran nama barang dari Firestore berdasarkan pola pencarian
                    final suggestions = await FirebaseFirestore.instance.collection('barang_items')
                      .where('name', isGreaterThanOrEqualTo: pattern)
                      .get();
                    return suggestions.docs.map((doc) => doc['name']).toList();
                  },
                ),
                SizedBox(height: 10),
                // TextFormField untuk memasukkan jumlah barang belanja
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Jumlah',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter jumlah';
                    }
                    return null;
                  },
                  onSaved: (value) =>
                      setState(() => _jumlah = int.parse(value!)), // Simpan jumlah barang belanja dari input pengguna
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tombol untuk membatalkan dialog
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save(); // Validasi dan simpan data dari form
                  setState(() {
                    _belanjaList
                        .add({'nama': _namaBelanja, 'jumlah': _jumlah}); // Tambahkan barang belanja ke dalam _belanjaList
                  });
                  Navigator.of(context).pop(); // Tutup dialog
                }
              },
              child: Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk mengirimkan data barang belanja ke Firestore
  void submitToFirebase() {
    _belanjaList.forEach((belanja) {
      FirebaseFirestore.instance.collection('user_selections').add({
        'name': belanja['nama'],
        'jumlah': belanja['jumlah'],
        'timestamp': FieldValue.serverTimestamp(),
      });
    });
  }

  // Fungsi untuk menghitung jumlah hari dalam bulan saat ini
  int daysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, 1);
    var firstDayNextMonth = DateTime(firstDayThisMonth.year, firstDayThisMonth.month + 1, 1);
    return firstDayNextMonth.subtract(Duration(days: 1)).day;
  }
}
