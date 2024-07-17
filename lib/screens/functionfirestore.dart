import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> addPurchase(String itemName, DateTime purchaseDate) async {
  await FirebaseFirestore.instance.collection('purchases').add({
    'item_name': itemName,
    'purchase_date': Timestamp.fromDate(purchaseDate),
  });
}

// fuctio show
Future<List<Map<String, dynamic>>> showPurchasesOnDate(DateTime date) async {
  // Start of the day
  DateTime start = DateTime(date.year, date.month, date.day, 0, 0, 0);
  // End of the day
  DateTime end = DateTime(date.year, date.month, date.day, 23, 59, 59);

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('purchases')
      .where('purchase_date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
      .where('purchase_date', isLessThanOrEqualTo: Timestamp.fromDate(end))
      .get();

  return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
}

// still function show but in UI

class ShowPurchasesScreen extends StatefulWidget {
  @override
  _ShowPurchasesScreenState createState() => _ShowPurchasesScreenState();
}

class _ShowPurchasesScreenState extends State<ShowPurchasesScreen> {
  late DateTime _selectedDate;
  List<Map<String, dynamic>> _purchases = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _fetchPurchases();
    }
  }

  Future<void> _fetchPurchases() async {
    List<Map<String, dynamic>> purchases = await showPurchasesOnDate(_selectedDate);
    setState(() {
      _purchases = purchases;
    });
  }

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Purchases'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'No Date Chosen!'
                        : 'Purchases on ${_formatDate(_selectedDate)}:',
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Choose Date'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _purchases.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_purchases[index]['item_name']),
                    subtitle: Text(_formatDate((_purchases[index]['purchase_date'] as Timestamp).toDate())),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> main() async {
  runApp(MaterialApp(
    home: ShowPurchasesScreen(),
  ));
}


