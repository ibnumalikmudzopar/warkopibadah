import 'package:flutter/material.dart';
import 'screens/barang.dart';
import 'screens/belanja.dart';
import 'screens/pesan.dart';
import 'screens/profile.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    BarangScreen(title: 'Warung Kopi Ibadah',),
    BelanjaScreen(),
    PesanScreen(),
    ProfileScreen(),
  ];

  final List<String> _appBarTitles = [
    'Daftar Barang',
    'Daftar Belanja',
    'Pesan',
    'Profile',
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
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Barang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Belanja',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Pesan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

/*
appBar: const MyAppBar(title: 'Warkop Ibadah'),
*/