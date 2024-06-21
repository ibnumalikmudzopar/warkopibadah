import 'package:flutter/material.dart';
import 'package:warkopibadah/widget/appbar.dart';
import 'package:warkopibadah/reusablecode.dart';

const List<String> kategoriList = ['Semua Kategori', 'ATK', 'Rokok', 'Pindang', 'Makanan', 'Minuman', 'Plastik', 'Lainnya'];

class Phonepotraitview extends StatefulWidget {
  const Phonepotraitview({ Key? key }) : super(key: key);

  @override
  _PhonepotraitviewState createState() => _PhonepotraitviewState();
}

class _PhonepotraitviewState extends State<Phonepotraitview> {
  String selectedKategori = 'Semua Kategori';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Warkop Ibadah'),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            title: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.add)),
                  IconButton(onPressed: (){}, icon: Icon(Icons.search)),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      value: selectedKategori,
                      hint: Text('Pilih Kategori'),
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
            bottom: PreferredSize(preferredSize: Size.fromHeight(50),
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Table(
                      columnWidths: {
                        0: FixedColumnWidth(50.0), // Kolom "No" dengan lebar tetap 50 piksel
                        1: FlexColumnWidth(1.0),
                      },
                      border: TableBorder.all(),
                      children: [
                        TableRow(
                          children: [
                            TableCell(child: Center(
                              child: Padding(padding: EdgeInsets.all(9.0),
                              child: Text("No", style: fontbold,),),
                            )),
                            TableCell(child: Center(
                              child: Padding(padding: EdgeInsets.all(9.0),
                              child: Text("Nama\nBarang", style: fontbold,),),
                            )),
                            TableCell(child: Center(
                              child: Padding(padding: EdgeInsets.all(9.0),
                              child: Text("Harga\nModal", style: fontbold,),),
                            )),
                            TableCell(child: Center(
                              child: Padding(padding: EdgeInsets.all(9.0),
                              child: Text("Harga\nJual/pcs", style: fontbold,),),
                            )),
                            TableCell(child: Center(
                              child: Padding(padding: EdgeInsets.all(9.0),
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
