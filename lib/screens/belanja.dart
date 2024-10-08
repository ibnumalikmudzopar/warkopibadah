import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

// Nama koleksi Firestore yang digunakan untuk menyimpan barang_items
const COLLECTION_NAME = 'barang_items';

class BelanjaScreen extends StatefulWidget {
  const BelanjaScreen({super.key});

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
  final List<Map<String, dynamic>> _belanjaList = []; // List untuk menyimpan daftar barang belanja yang akan ditampilkan di DataTable
  List<String> _namaBarang = []; // List untuk menyimpan nama barang dari Firestore untuk saran autocomplete
  final TextEditingController searchNamaBarangController = TextEditingController(); // Controller untuk field pencarian nama barang
  bool showDetail = false; // Status untuk menampilkan atau menyembunyikan detail belanja
  DateTime? selectedDate; // Variabel untuk menyimpan tanggal yang dipilih untuk detail belanja
  String _selectedOption = 'pak'; // Variabel untuk menyimpan nilai dropdown

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
    var list = records.docs.map((item) => item['name'] as String).toList();
    setState(() {
      _namaBarang = list; // Perbarui _namaBarang dengan data yang diambil dari Firestore
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
    body: showDetail
        ? _buildDetailBelanja() // Tampilkan detail belanja jika showDetail true
        : showForm
            ? SingleChildScrollView(
                child: _buildForm(),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        monthName,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: daysOfWeek.map((day) => Expanded(
                            child: Center(
                              child: Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          )).toList(),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                        ),
                        itemCount: daysInMonth(now) + startWeekday,
                        itemBuilder: (context, index) {
                          if (index < startWeekday) {
                            return const Center(child: Text(''));
                          }
                          DateTime date = DateTime(now.year, now.month, index - startWeekday + 1);
                          bool isToday = date.day == now.day && date.month == now.month && date.year == now.year;
                          return GestureDetector(
                            onTap: () => _showDetailBelanja(date),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start, // Mengatur posisi teks di atas
                                children: [
                                  Text(
                                    DateFormat.d().format(date),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                      color: isToday ? Colors.blue : Colors.black,
                                    ),
                                  ),
                                  const Text('')
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showForm = true;
                          });
                        },
                        child: const Icon(Icons.add),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
    );
  }

  Widget _buildDetailBelanja() {
  return FutureBuilder(
    future: _fetchBelanjaData(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        var belanjaList = snapshot.data as List<Map<String, dynamic>>;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Detail Belanja ${DateFormat.yMMMMd().format(selectedDate!)}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: belanjaList.length,
                  itemBuilder: (context, index) {
                    var item = belanjaList[index];
                    return ListTile(
                      title: Text(item['name']),
                      subtitle: Column(
                        children: [
                          Text('Jumlah: ${item['jumlah']}'),
                          Text('Jumlah: ${item['jumlahpak']}'),
                        ],
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showDetail = false; // Kembali ke tampilan utama
                    selectedDate = null; // Reset tanggal yang dipilih
                  });
                },
                child: const Text('Kembali'),
              ),
            ],
          ),
        );
      }
    },
  );
}

Future<List<Map<String, dynamic>>> _fetchBelanjaData() async {
  String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
  var querySnapshot = await FirebaseFirestore.instance
      .collection('belanja_items')
      .doc(formattedDate)
      .collection('items')
      .get();
  return querySnapshot.docs.map((doc) => doc.data()).toList();
}


  // Widget untuk membangun form penambahan barang belanja
  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            height: 300,
            width: 500,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('No.')), // Kolom untuk nomor urut
                  DataColumn(label: Text('Nama Barang')), // Kolom untuk nama barang
                  DataColumn(label: Text('Jumlah')), // Kolom untuk nama barang
                  DataColumn(label: Text('Opsi')),// Kolom untuk jumlah barang
                ],
                rows: _belanjaList
                .asMap()
                .entries
                .map(
                  (entry) => DataRow(
                    cells: [
                      DataCell(Text((entry.key + 1).toString())), // Sel untuk nomor urut
                      DataCell(Text(entry.value['nama'])), // Sel untuk nama barang
                      DataCell(Text(entry.value['jumlah'].toString())),// Sel untuk jumlah barang
                      DataCell(Text(entry.value['opsi'])),
                    ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(onPressed: () {
                setState(() {
                  _belanjaList.clear(); // Tombol untuk menghapus semua item dari _belanjaList
                });
              }, child: const Text("Reset")),
              ElevatedButton(
                onPressed: () {
                  submitToFirebase(); // Tombol untuk mengirim data barang belanja ke Firebase
                },
                child: const Text('Submit to Firebase'),
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: _showAddBarangDialog, // Tombol untuk menampilkan dialog penambahan barang belanja
                  child: const Text("Tambah")),
              ElevatedButton(onPressed: () {
                setState(() {
                  showForm = false; // Tombol untuk kembali ke tampilan utama dari form
                });
              }, child: const Text("Kembali"))
            ],
          )
        ],
      ),
    );
  }

  void _showDetailBelanja(DateTime date) {
  setState(() {
    selectedDate = date; // Simpan tanggal yang dipilih
    showDetail = true; // Tampilkan detail belanja
  });
}


  // Fungsi untuk menampilkan dialog penambahan barang belanja
  void _showAddBarangDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Belanja'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                // TypeAheadField untuk memberikan saran nama barang berdasarkan input pengguna
                TypeAheadField(
                  builder: (context, searchNamaBarangcontroller, focusNode){
                    return TextField(
                      controller: searchNamaBarangcontroller,
                      focusNode: focusNode,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nama Barang',
                      ),
                    );
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion.toString()),
                    );
                  },
                  onSelected: (suggestion) {
                    setState(() {
                      _namaBelanja = suggestion.toString(); // Update _namaBelanja dengan pilihan pengguna
                      searchNamaBarangController.text = _namaBelanja; // Update controller untuk field pencarian
                      
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
                const SizedBox(height: 10),
                // TextFormField untuk memasukkan jumlah barang belanja
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Jumlah',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jumlah tidak boleh kosong';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Jumlah harus berupa angka';
                    }
                    return null;
                  },
                  onSaved: (value) =>
                      setState(() => _jumlah = int.parse(value!)), // Simpan jumlah barang belanja dari input pengguna
                ),
                DropdownButtonFormField<String>(
                  value: _selectedOption,
                  items: ['pak', 'runtui'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedOption = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Opsi',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tombol untuk membatalkan dialog
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save(); // Validasi dan simpan data dari form
                  setState(() {
                    _belanjaList
                        .add({'nama': _namaBelanja, 'jumlah': _jumlah, 'opsi': _selectedOption}); // Tambahkan barang belanja ke dalam _belanjaList
                  });
                  Navigator.of(context).pop(); // Tutup dialog
                }
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  // // Fungsi untuk mengirimkan data barang belanja ke Firestore
  // void submitToFirebase() {
  //   _belanjaList.forEach((belanja) {
  //     FirebaseFirestore.instance.collection('belanja_items').add({
  //       'name': belanja['nama'],
  //       'jumlah': belanja['jumlah'],
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });
  //   });
  // }

  // void submitToFirebase() {
  // String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  // CollectionReference belanjaCollection = FirebaseFirestore.instance.collection('belanja_items');

  // _belanjaList.forEach((belanja) {
  //   belanjaCollection
  //     .doc(formattedDate) // ID dokumen adalah tanggal
  //     .collection('items') // Subkoleksi 'items'
  //     .add({
  //       'name': belanja['nama'],
  //       'jumlah': belanja['jumlah'],
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });
  // });
  // }

  void submitToFirebase() {
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    CollectionReference belanjaCollection = FirebaseFirestore.instance.collection('belanja_items');

    for (var belanja in _belanjaList) {
      belanjaCollection
        .doc(formattedDate) // ID dokumen adalah tanggal
        .collection('items') // Subkoleksi 'items'
        .add({
          'name': belanja['nama'],
          'jumlah': belanja['jumlah'],
          'jumlahpak': belanja['opsi'],
          'timestamp': FieldValue.serverTimestamp(),
        }).then((value) {
          // Menampilkan Snackbar ketika data berhasil ditambahkan
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data berhasil ditambahkan!'),
            ),
          );
        }).catchError((error) {
          // Menampilkan Snackbar ketika terjadi error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menambahkan data: $error'),
            ),
          );
        });
    }
  }

  // Fungsi untuk menghitung jumlah hari dalam bulan saat ini
  int daysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, 1);
    var firstDayNextMonth = DateTime(firstDayThisMonth.year, firstDayThisMonth.month + 1, 1);
    return firstDayNextMonth.subtract(const Duration(days: 1)).day;
  }
}
