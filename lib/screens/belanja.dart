import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BelanjaScreen extends StatefulWidget {
  BelanjaScreen({Key? key}) : super(key: key);

  @override
  _BelanjaScreenState createState() => _BelanjaScreenState();
}

class _BelanjaScreenState extends State<BelanjaScreen> {
  final List<String> daysOfWeek = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
  bool showForm = false; // Menyimpan status apakah form ditampilkan atau tidak

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String monthName = DateFormat.yMMMM().format(now);
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    int startWeekday = firstDayOfMonth.weekday % 7; // 0 untuk Minggu, 1 untuk Senin, dst.

    return Scaffold(
      body: Padding(
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
                    showForm = true; // Setelah tombol ditekan, tampilkan form
                  });
                },
                child: Icon(Icons.add),
              ),
            ),
            SizedBox(height: 20),
            if (showForm)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Form Belanja',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showForm = false; // Saat tombol 'Kembali' ditekan, sembunyikan form
                            });
                          },
                          child: Text('Kembali'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Nama Barang'),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Nama Barang'),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Nama Barang'),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Nama Barang'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Logika untuk menyimpan data dari form
                      },
                      child: Text('Simpan'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  int daysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, 1);
    var firstDayNextMonth = DateTime(firstDayThisMonth.year, firstDayThisMonth.month + 1, 1);
    return firstDayNextMonth.subtract(Duration(days: 1)).day;
  }
}


