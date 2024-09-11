import 'package:flutter/material.dart';
import 'package:warkopibadah/widget/appbar.dart';
import 'package:warkopibadah/reusablecode.dart';

const List<String> kategoriList = ['Semua Kategori', 'ATK', 'Rokok', 'Pindang', 'Makanan', 'Minuman', 'Plastik', 'Lainnya'];

class Phonepotraitview extends StatefulWidget {
  const Phonepotraitview({ super.key });

  @override
  _PhonepotraitviewState createState() => _PhonepotraitviewState();
}

class _PhonepotraitviewState extends State<Phonepotraitview> {
  String selectedKategori = 'Semua Kategori';

  @override
  Widget build(BuildContext context) {
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
                  IconButton(onPressed: (){}, icon: const Icon(Icons.add)),
                  IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
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
                    Table(
                      columnWidths: const {
                        0: const FixedColumnWidth(50.0), // Kolom "No" dengan lebar tetap 50 piksel
                        1: const FlexColumnWidth(1.0),
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
                              child: Text("Harga\nModal", style: fontbold,),),
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
                    )
                  ],
                ),
              )),
          )
        ],
      ),
    );
  }
}
