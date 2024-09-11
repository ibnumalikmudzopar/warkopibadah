import 'package:flutter/material.dart';
import 'screens/barang.dart';
import 'screens/belanja.dart';
import 'screens/bontoko.dart';
import 'screens/profile.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const BarangScreen(title: 'Daftar Barang',),
    const Bontoko(),
    BelanjaScreen(),
    ProfileScreen(),
  ];

  final List<String> _appBarTitles = [
    'Harga Jual Barang',
    'Harga Beli Barang',
    'Daftar Belanja',
    'User',
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_currentIndex]),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.black, // Warna item terpilih
        unselectedItemColor: Colors.grey, // Warna item tidak terpilih
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Harga Jual Barang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.price_check),
            label: 'Harga Beli Barang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Daftar Belanja',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2),
            label: 'User',
          ),
        ],
      ),
    );
  }
}

/*
appBar: const MyAppBar(title: 'Warkop Ibadah'),
*/