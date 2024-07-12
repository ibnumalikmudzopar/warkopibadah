import 'package:flutter/material.dart';

class BelanjaScreen extends StatefulWidget {
  @override
  _BelanjaScreenState createState() => _BelanjaScreenState();
}

class _BelanjaScreenState extends State<BelanjaScreen> {
  late PageController _pageController;
  DateTime _currentDate = DateTime.now();

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
                child: Text(
                  _getMonthName(date.month),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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

Widget _buildMonthView(DateTime date) {
  List<String> daysOfWeek = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
  List<Widget> dayWidgets = [];

<<<<<<< HEAD
  // Add day of week headers
  for (String day in daysOfWeek) {
    dayWidgets.add(
      Container(
        alignment: Alignment.center,
        child: Text(
          day,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
=======
    // Tambahkan nama hari
    for (String day in daysOfWeek) {
      dayWidgets.add(
        Container(
          alignment: Alignment.center,
          child: Text(
            day,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      );
    }

    int daysInMonth = DateUtils.getDaysInMonth(date.year, date.month);
    int firstWeekday = DateTime(date.year, date.month, 1).weekday - 1; // Adjusting to start from Monday

    // Tambahkan kotak kosong untuk hari sebelum tanggal 1
    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(Container());
    }

    // Tambahkan tanggal
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
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      '$i',
                      style: TextStyle(color: isToday ? Colors.red : Colors.white),
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
>>>>>>> ca2d5e36b815eb07a1333263fab667379a439a45
        ),
      ),
    );
  }

  int daysInMonth = DateTime(date.year, date.month + 1, 0).day;
  int firstWeekday = DateTime(date.year, date.month, 1).weekday - 1; // Adjusting to start from Monday

  // Add empty containers for days before the 1st
  for (int i = 0; i < firstWeekday; i++) {
    dayWidgets.add(
      Container(
        height: 40.0,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
    );
  }

  // Add dates
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
          height: 40.0,
          alignment: Alignment.center,
          margin: EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: isToday ? Colors.red.shade100 : Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          child: Text(
            '$i',
            style: TextStyle(color: isToday ? Colors.red : Colors.black),
          ),
        ),
      ),
    );
  }

  return GridView.count(
    crossAxisCount: 7,
    childAspectRatio: 1.5,
    children: dayWidgets,
  );
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
}