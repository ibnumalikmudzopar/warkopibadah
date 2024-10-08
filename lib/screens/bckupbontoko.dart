// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:warkopibadah/bontokoitem.dart';

// class Bontoko extends StatefulWidget {
//   const Bontoko({Key? key}) : super(key: key);

//   @override
//   _BontokoState createState() => _BontokoState();
// }

// class _BontokoState extends State<Bontoko> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String _collectionName = 'bontoko_items';

//   DateTime parseTimestamp(dynamic timestamp) {
//     if (timestamp is Timestamp) {
//       return timestamp.toDate();
//     } else if (timestamp == null) {
//       return DateTime.now(); // Atur default jika timestamp null
//     } else {
//       throw ArgumentError('Invalid timestamp');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _firestore.collection(_collectionName).snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No data found'));
//           }

//           List<BonTokoItem> _bonTokoItems = snapshot.data!.docs.map((item) {
//             return BonTokoItem(
//               jumlah: item['jumlah']?.toString() ?? '0',
//               isi: item['isi'] ?? '',
//               nama: item['nama'] ?? '',
//               kategori: item['kategori'] ?? '',
//               harga: item['harga']?.toString() ?? '0',
//               lastupdate: parseTimestamp(item['lastupdate']),
//             );
//           }).toList();

//           return CustomScrollView(
//             slivers: <Widget>[
//               SliverToBoxAdapter(
//                 child: Table(
//                   border: TableBorder.all(color: Colors.transparent),
//                   columnWidths: {
//                     0: FlexColumnWidth(0.5),
//                     1: FlexColumnWidth(1.1),
//                     2: FlexColumnWidth(0.5),
//                     3: FlexColumnWidth(2.0),
//                     4: FlexColumnWidth(1.5),
//                     5: FlexColumnWidth(0.8),
//                   },
//                   children: [
//                     TableRow(
//                       children: [
//                         TableCell(child: Text('No')),
//                         TableCell(child: Text('Jumlah')),
//                         TableCell(child: Text('Isi')),
//                         TableCell(child: Text('Nama')),
//                         TableCell(child: Text('Harga')),
//                         TableCell(child: Text('Time')),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               SliverList(
//                 delegate: SliverChildBuilderDelegate(
//                   (BuildContext context, int index) {
//                     final item = _bonTokoItems[index];
//                     return Slidable(
//                       endActionPane: ActionPane(
//                         motion: const ScrollMotion(),
//                         children: [
//                           SlidableAction(
//                             onPressed: (context) {
//                               // deleteItem(item.id);
//                             },
//                             backgroundColor: Colors.red,
//                             foregroundColor: Colors.white,
//                             icon: Icons.delete,
//                             spacing: 8,
//                           ),
//                           SlidableAction(
//                             onPressed: (context) {
//                               // editItem(item);
//                             },
//                             backgroundColor: Colors.blue,
//                             foregroundColor: Colors.white,
//                             icon: Icons.edit,
//                             spacing: 8,
//                           ),
//                         ],
//                       ),
//                       child: Table(
//                         columnWidths: {
//                           0: FlexColumnWidth(0.5),
//                           1: FlexColumnWidth(1.1),
//                           2: FlexColumnWidth(0.5),
//                           3: FlexColumnWidth(2.0),
//                           4: FlexColumnWidth(1.5),
//                           5: FlexColumnWidth(0.8),
//                         },
//                         border: TableBorder.all(color: Colors.transparent),
//                         children: [
//                           TableRow(
//                             children: [
//                               TableCell(child: Text((index + 1).toString())),
//                               TableCell(child: Text(item.jumlah)),
//                               TableCell(child: Text(item.isi)),
//                               TableCell(child: Text(item.nama)),
//                               TableCell(child: Text(item.harga)),
//                               TableCell(child: Text(DateFormat('yyyy-MM-dd').format(item.lastupdate))),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                   childCount: _bonTokoItems.length,
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: showAddDialog,
//         child: Icon(Icons.add),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//     );
//   }

//   showAddDialog() {
//     var jumlahController = TextEditingController();
//     var isiController = TextEditingController();
//     var namaController = TextEditingController();
//     var hargaController = TextEditingController();

//     var _currencies = [
//       "Rokok",
//       "Makanan",
//       "Minuman",
//       "Pindang",
//       "ATK",
//       "Plastik",
//       "Lainnya",
//     ];

//     String _currentSelectedKategori = _currencies[0];

//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Center(
//                       child: const Text('Detail Barang', style: TextStyle(fontSize: 20)),
//                     ),
//                     const SizedBox(height: 20),
//                     TextField(
//                       controller: jumlahController,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(13.0),
//                         ),
//                         labelText: 'Jumlah',
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     TextField(
//                       controller: isiController,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(13.0),
//                         ),
//                         labelText: 'Isi',
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     TextField(
//                       controller: namaController,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(13.0),
//                         ),
//                         labelText: 'Nama',
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     FormField<String>(
//                       builder: (FormFieldState<String> state) {
//                         return InputDecorator(
//                           decoration: InputDecoration(
//                             labelText: 'Pilih Kategori',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                             ),
//                           ),
//                           isEmpty: _currentSelectedKategori == '',
//                           child: DropdownButtonHideUnderline(
//                             child: DropdownButton<String>(
//                               value: _currentSelectedKategori,
//                               isDense: true,
//                               onChanged: (String? newValue) {
//                                 setState(() {
//                                   _currentSelectedKategori = newValue ?? _currencies[0];
//                                   state.didChange(newValue);
//                                 });
//                               },
//                               items: _currencies.map((String value) {
//                                 return DropdownMenuItem<String>(
//                                   value: value,
//                                   child: Text(value),
//                                 );
//                               }).toList(),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 10),
//                     TextField(
//                       controller: hargaController,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(13.0),
//                         ),
//                         labelText: 'Harga',
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         var jumlah = jumlahController.text.trim();
//                         var isi = isiController.text.trim();
//                         var nama = namaController.text.trim();
//                         var kategori = _currentSelectedKategori;
//                         var harga = hargaController.text.trim();
//                         var lastupdate = DateTime.now();
//                         addItem(jumlah, isi, nama, harga, kategori, lastupdate);
//                         Navigator.of(context).pop();
//                       },
//                       child: const Text('Simpan'),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Future<void> addItem(String jumlah, String isi, String nama, String harga, String kategori, DateTime lastupdate) async {
//     try {
//       await _firestore.collection(_collectionName).add({
//         'jumlah': jumlah,
//         'isi': isi,
//         'nama': nama,
//         'kategori': kategori,
//         'harga': harga,
//         'lastupdate': Timestamp.fromDate(lastupdate),
//       });
//     } catch (e) {
//       print('Failed to add item: $e');
//     }
//   }

//   showUpdateDialog(){
    
//   }
// }
