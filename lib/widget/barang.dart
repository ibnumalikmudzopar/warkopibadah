import 'package:cloud_firestore/cloud_firestore.dart'; // Package untuk Firebase Firestore
import 'package:flutter/material.dart'; // Package dasar dari Flutter
import 'package:flutter/widgets.dart';
import 'package:warkopibadah/widget/bottomnavbar.dart';
import 'item.dart'; // File dengan definisi kelas Item
import 'package:flutter_slidable/flutter_slidable.dart'; // Package untuk item slideable
import 'reusablecode.dart';
import 'widget/appbar.dart';


// Konstanta untuk nama koleksi di Firestore
const COLLECTION_NAME = 'barang_items';
const List<String> kategoriList = ['Semua Kategori', 'ATK', 'Rokok', 'Pindang', 'Makanan', 'Minuman', 'Plastik', 'Lainnya'];
// Buat variabel baru untuk kategori tanpa "Semua Kategori"
final List<String> filteredKategoriList = kategoriList.where((kategori) => kategori != 'Semua Kategori').toList();

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Item> barangItems = []; // Daftar barang
  String selectedKategori = 'Semua Kategori';
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

/*
-------------------------------------------------------------------------------------------------------------
-----------------------------------FIREBASE------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
*/

  @override
  void initState() {
    fetchRecords(); // Memanggil metode untuk mengambil data dari Firestore saat inisialisasi
    // Mendengarkan perubahan data Firestore
    FirebaseFirestore.instance.collection(COLLECTION_NAME).snapshots().listen((records) {
      mapRecords(records); // Memetakan data Firestore ke dalam objek Item saat ada perubahan
    });
    super.initState();
  }

  // Metode untuk mengambil data dari Firestore
  fetchRecords() async {
    var records = await FirebaseFirestore.instance.collection(COLLECTION_NAME).get();
    mapRecords(records); // Memetakan data Firestore ke dalam objek Item
  }

  // Metode untuk memetakan data Firestore ke dalam objek Item
  mapRecords(QuerySnapshot<Map<String, dynamic>> records) {
    var _list = records.docs.map(
      (item) => Item(
        id: item.id,
        name: item['name'],
        hargapcs: item['hargapcs'],
        hargapak: item['hargapak'],
        kategori: item['kategori'],
        modal: item['modal'],
      ),
    ).toList();

    setState(() {
      barangItems = _list; // Memperbarui daftar barang
    });
  }

  // Metode untuk memfilter item berdasarkan kategori
  // List<Item> getFilteredItems() {
  //   if (selectedKategori == 'Semua Kategori') {
  //     return barangItems; // Jika kategori tidak dipilih, tampilkan semua item
  //   }
  //   // if (selectedKategori == 'Lainnya') {
  //   //   return barangItems.where((item) => !kategoriList.contains(item.kategori)).toList();
  //   // }
  //   return barangItems.where((item) => item.kategori == selectedKategori).toList();
  // }
 
  List<Item> getFilteredItems() {
  List<Item> items = barangItems;
  if (selectedKategori != 'Semua Kategori') {
    items = items.where((item) => item.kategori == selectedKategori).toList();
  }
  if (searchController.text.isNotEmpty) {
    items = items.where((item) =>
      item.name.toLowerCase().contains(searchController.text.toLowerCase())
    ).toList();
  }
  return items;
}


  // Metode untuk mengurutkan barangItems berdasarkan nama barang
  void sortItemsByName() {
    barangItems.sort((a, b) => a.name.compareTo(b.name));
  }
  

/*
-------------------------------------------------------------------------------------------------------------
-----------------------------UI------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
*/

  @override
  Widget build(BuildContext context) {

    // Panggil metode untuk mengurutkan barangItems sebelum membangun tampilan
    sortItemsByName();
    List<Item> filteredItems = getFilteredItems(); // Dapatkan item yang sudah difilter
    return Scaffold(
      appBar: const MyAppBar(title: 'Warkop Ibadah'),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            title: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: showAddDialog, icon: const Icon(Icons.add)),
                  IconButton(
                    onPressed: (){
                      setState(() {
                        isSearching = !isSearching;
                        if (!isSearching) {
                        searchController.clear(); // Clear search input when closing search
                      }
                      });
                    },
                    icon: Icon(isSearching ? Icons.close : Icons.search),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      value: selectedKategori,
                      hint: const Text('Pilih Kategori'),
                      items: kategoriList.map<DropdownMenuItem<String>>((String kategori) {
                          return DropdownMenuItem<String>(
                            value: kategori,
                            child: Text(kategori),
                          );
                        }).toList(),
                      onChanged: (String? newValue) {
                          setState(() {
                            selectedKategori = newValue!;
                          });
                      },
                    ),
                  )
                ],
              ),
            ),
            bottom: PreferredSize(preferredSize: const Size.fromHeight(50),
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    if(isSearching)
                    SingleChildScrollView(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari barang...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          // suffixIcon: IconButton(
                          //   onPressed: (){
                          //     isSearching = false;
                          //     searchController.clear();
                          // }, icon: Icon(Icons.waves))
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    if(!isSearching)
                    Table(
                      columnWidths: const {
                        0: FixedColumnWidth(50.0), // Kolom "No" dengan lebar tetap 50 piksel
                        1: FlexColumnWidth(1.0),
                      },
                      border: TableBorder.all(),
                      children: [
                        TableRow(
                          children: [
                            TableCell(child: Center(
                              child: Padding(padding: const EdgeInsets.all(9.0),
                              child: Text("No", style: fontbold,),),
                            )),
                            TableCell(child: Center(
                              child: Padding(padding: const EdgeInsets.all(9.0),
                              child: Text("Nama\nBarang", style: fontbold,),),
                            )),
                            TableCell(child: Center(
                              child: Padding(padding: const EdgeInsets.all(9.0),
                              child: Text("Harga\nJual/pcs", style: fontbold,),),
                            )),
                            TableCell(child: Center(
                              child: Padding(padding: const EdgeInsets.all(9.0),
                              child: Text("Harga\nJual/pak", style: fontbold,),),
                            )),
                          ]
                        )
                      ],
                    ),
                  ],
                ),
              )),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context, int index){
              var item = filteredItems[index];
              return Slidable(
                endActionPane: 
                ActionPane(motion: const ScrollMotion(),
                children: [
                  SlidableAction(onPressed: (context){
                      deleteItem(item.id);
                    },
                    backgroundColor: Colors.red, foregroundColor: Colors.white, icon: Icons.delete,
                    // label: 'Delete',
                    spacing: 8,
                  ),
                  SlidableAction(
                        onPressed: (context) {
                          showUpdateDialog(item.id, item.name, item.hargapcs, item.hargapak, item.kategori??'', item.modal ?? '');
                        },
                        backgroundColor: Colors.yellow,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        // label: 'Edit',
                        // spacing: 8,
                  ),
                  SlidableAction(
                    onPressed: null,
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    label: 'M: ${item.modal}',
                    spacing: 8,
                  )
                ]
                ),
                child: Table(
                  columnWidths: const {
                        0: FixedColumnWidth(50.0), // Kolom "No" dengan lebar tetap 50 piksel
                        1: FlexColumnWidth(1.0),
                      },
                  border: TableBorder.all(),
                  children: [
                    TableRow(
                      children: [
                        TableCell(child: Center(child: Padding(padding: const EdgeInsets.all(7.0), child: Text((index + 1).toString()),),)),
                        TableCell(child: Center(child: Padding(padding: const EdgeInsets.all(7.0), child: Text(item.name),),)),
                        TableCell(child: Center(child: Padding(padding: const EdgeInsets.all(7.0), child: Text(item.hargapcs),),)),
                        TableCell(child: Center(child: Padding(padding: const EdgeInsets.all(7.0), child: Text(item.hargapak),),)),
                      ],
                    ),
                  ],
                ),
              );
            },
            childCount: filteredItems.length
            ))
        ],
      ),
      // bottomNavigationBar: const BottomNavigationbar()
    );
  }

/*
-------------------------------------------------------------------------------------------------------------
--------------------------------------------LOGIKA APLIKASI--------------------------------------------------
-------------------------------------------------------------------------------------------------------------
*/

  showAddDialog() {
  var nameController = TextEditingController();
  var hargapcsController = TextEditingController();
  var hargapakController = TextEditingController();
  var modalController = TextEditingController();

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
                  const Text('Detail Barang', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      labelText: 'Nama Barang',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: hargapcsController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      labelText: 'Harga Barang / pcs',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: hargapakController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      labelText: 'Harga Barang / pak',
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
                    controller: modalController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      labelText: 'Harga Modal',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Implementasi logika tambah barang disini
                      var name = nameController.text.trim();
                      var hargapcs = hargapcsController.text.trim();
                      var hargapak = hargapakController.text.trim();
                      var modal = modalController.text.trim();
                      addItem(name, hargapcs, hargapak, _currentSelectedKategori, modal);
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

  // Metode untuk menampilkan dialog pembaruan barang
showUpdateDialog(String id, String currentName, String currentHargapcs, String currentHargapak, String currentKategori, String currentModal) {
  var nameController = TextEditingController(text: currentName);
  var hargapcsController = TextEditingController(text: currentHargapcs);
  var hargapakController = TextEditingController(text: currentHargapak);
  var modalController = TextEditingController(text: currentModal);
  String _currentSelectedValue = currentKategori; // Inisialisasi kategori dengan nilai saat ini

  showDialog(context: context, builder: (context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Item Detail'),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nama Barang')),
            TextField(controller: hargapcsController, decoration: const InputDecoration(labelText: 'Harga Barang / pcs')),
            TextField(controller: hargapakController, decoration: const InputDecoration(labelText: 'Harga Barang / pak')),
            const SizedBox(height: 10),
            FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(),
                  ),
                  isEmpty: _currentSelectedValue == '',
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _currentSelectedValue,
                      isDense: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          _currentSelectedValue = newValue ?? ''; // Handle nullable value jika diperlukan
                          state.didChange(newValue);
                        });
                      },
                      items: filteredKategoriList.map((String value) {
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
            TextField(controller: modalController, decoration: const InputDecoration(labelText: 'Modal')),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  var name = nameController.text.trim();
                  var hargapcs = hargapcsController.text.trim();
                  var hargapak = hargapakController.text.trim();
                  var kategori = _currentSelectedValue;
                  var modal = modalController.text.trim(); // Ambil kategori yang dipilih dari dropdown

                  updateItem(id, name, hargapcs, hargapak, kategori, modal); // Memperbarui data barang
                  Navigator.pop(context); // Menutup dialog setelah memperbarui barang
                },
                child: const Text('Update Data'),
              ),
            ),
          ],
        ),
      ),
    );
  });
}

// Metode untuk menambahkan barang baru ke Firestore
addItem(String name, String hargapcs, String hargapak, String kategori, String modal) {
    var item = Item(id: 'id', name: name, hargapcs: hargapcs, hargapak: hargapak, kategori: kategori, modal: modal);
    FirebaseFirestore.instance.collection(COLLECTION_NAME).add(item.toJson());
  }

// Metode untuk memperbarui data barang di Firestore
  updateItem(String id, String name, String hargapcs, String hargapak,  String kategori, String modal) {
    FirebaseFirestore.instance.collection(COLLECTION_NAME).doc(id).update(
        {
          "name": name,
          "hargapcs": hargapcs,
          "hargapak": hargapak,
          "kategori": kategori,
          "modal": modal,
        }
    );
  }

  // Metode untuk menghapus barang dari Firestore
  deleteItem(String id) {
    FirebaseFirestore.instance.collection(COLLECTION_NAME).doc(id).delete();
  }

}


// move code home.dart ke sini
// buat folder screen dan pindahkan barang,belanja dan pesan.dart 