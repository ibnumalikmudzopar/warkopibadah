import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:warkopibadah/screens/addbelanja.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this line

class BelanjaScreen extends StatefulWidget {
  BelanjaScreen({Key? key}) : super(key: key);

  @override
  _BelanjaScreenState createState() => _BelanjaScreenState();
}

class _BelanjaScreenState extends State<BelanjaScreen> {
  final List<String> daysOfWeek = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
  bool showForm = false; // Menyimpan status apakah form ditampilkan atau tidak
  final _formKey = GlobalKey<FormState>(); // Add this line
  String _namaBelanja = ''; // Add this line
  int _jumlah = 0; // Add this line
  List<Map<String, dynamic>> _belanjaList = []; // Add this line

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String monthName = DateFormat.yMMMM().format(now);
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    int startWeekday = firstDayOfMonth.weekday % 7; // 0 untuk Minggu, 1 untuk Senin, dst.

    return Scaffold(
      body: showForm
         ? _buildForm()
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
                              fontWeight: isToday? FontWeight.bold : FontWeight.normal,
                              color: isToday? Colors.red : Colors.black,
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
                          showForm = true;
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

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nama Belanja',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter nama belanja';
                    }
                    return null;
                  },
                  onSaved: (value) => _namaBelanja = value!,
                ),
                SizedBox(height: 10),
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
                  onSaved: (value) => _jumlah = int.parse(value!),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    setState(() {
                      _belanjaList.add({'nama': _namaBelanja, 'jumlah': _jumlah});
                    });
                  }
                },
                child: Text('Tambah'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showForm = false;
                  });
                },
                child: Text('Kembali'),
              ),
            ],
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
          scrollDirection: Axis.vertical, // Add this line
          child: DataTable(
            columns: [
              DataColumn(label: Text('Nama Belanja')),
              DataColumn(label: Text('Jumlah')),
            ],
            rows: _belanjaList
               .map(
                  (belanja) => DataRow(
                    cells: [
                      DataCell(Text(belanja['nama'])),
                      DataCell(Text(belanja['jumlah'].toString())),
                    ],
                  ),
                )
               .toList(),
          ),
        ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: (){},
            child: Text('Submit to Firebase'),
          ),
        ],
      ),
    );
  }

  int daysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, 1);
    var firstDayNextMonth = DateTime(firstDayThisMonth.year, firstDayThisMonth.month + 1, 1);
    return firstDayNextMonth.subtract(Duration(days: 1)).day;
  }
}