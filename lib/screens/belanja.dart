import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import

class BelanjaScreen extends StatefulWidget {
  @override
  _BelanjaScreenState createState() => _BelanjaScreenState();
}

class _BelanjaScreenState extends State<BelanjaScreen> {
  late PageController _pageController;
  DateTime _currentDate = DateTime.now();

  /*
  -------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------FIREBASE------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------------
  */

  // TableCell(child: Center(child: Padding(padding: const EdgeInsets.all(7.0), child: Text(item.hargapak),),)),
  // item.id 
  // add to belanja_items
  // item.id,
  // banyaknya: 2,
  // tanggal: time.now()
  /*
  Metode untuk menambahkan barang baru ke Firestore
  addItem(String name, String hargapcs, String hargapak, String kategori, String modal) {
    var item = Item(id: 'id', name: name, hargapcs: hargapcs, hargapak: hargapak, kategori: kategori, modal: modal);
    FirebaseFirestore.instance.collection(COLLECTION_NAME).add(item.toJson());
  }
  */

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentDate.month - 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentDate = DateTime(_currentDate.year, index + 1);
          });
        },
        itemBuilder: (context, index) {
          DateTime date = DateTime(_currentDate.year, index + 1);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      _getMonthName(date.month),
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${date.year}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Expanded(child: _buildMonthView(date)),
            ],
          );
        },
      ),
    );
  }

  String _getMonthName(int month) {
    List<String> monthNames = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return monthNames[month - 1];
  }

  void _showExpenseDetails(int year, int month, int day) {
    // Implementasi detail belanja berdasarkan tanggal yang diklik
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detail Belanja'),
          content: Text('Belanja pada $day/$month/$year'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMonthView(DateTime date) {
  List<String> daysOfWeek = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
  List<Widget> dayWidgets = [];

  // Add day of week headers
  for (String day in daysOfWeek) {
    dayWidgets.add(
      Container(
        alignment: Alignment.center,
        child: Text(
          day,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }

  // Add empty containers for days before the 1st
  int firstWeekday = DateTime(date.year, date.month, 1).weekday - 1;
  for (int i = 0; i < firstWeekday; i++) {
    dayWidgets.add(Container());
  }

  // Add dates
  int daysInMonth = DateTime(date.year, date.month + 1, 0).day;
  for (int i = 1; i <= daysInMonth; i++) {
    bool isToday = date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        i == DateTime.now().day;

    dayWidgets.add(
      GestureDetector(
        onTap: () {
          _showExpenseDetails(date.year, date.month, i);
        },
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: isToday ? Colors.red.shade100 : Colors.transparent,
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    '$i',
                    style: TextStyle(color: isToday ? Colors.red : Colors.green),
                  ),
                ),
              ),
              if (i == 11 || i == 7) // Contoh untuk menambahkan ikon bulat
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 24.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      color: i == 11 ? Colors.red : Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '1',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  return GridView.count(
    crossAxisCount: 7,
    childAspectRatio: 0.8,
    children: dayWidgets,
  );
}}