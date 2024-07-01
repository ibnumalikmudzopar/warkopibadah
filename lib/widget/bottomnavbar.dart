import 'package:flutter/material.dart';
import 'package:warkopibadah/belanja.dart';
import 'package:warkopibadah/home.dart';
import 'package:warkopibadah/pesan.dart';

class BottomNavigationbar extends StatefulWidget {
  const BottomNavigationbar({ Key? key }) : super(key: key);

  @override
  _BottomNavigationbarState createState() => _BottomNavigationbarState();
}

class _BottomNavigationbarState extends State<BottomNavigationbar> {

  int _currentTabIndex = 0;
  final List<Widget> _kTabPages = <Widget> [
    const Home(title: 'Warkop Ibadah'),
    Belanja(),
    Pesan(),
  ];

   final List <BottomNavigationBarItem> _kBottomNavBarItems = <BottomNavigationBarItem> [
   const BottomNavigationBarItem (icon: Icon  (Icons.table_view), label: 'Barang'),
   const BottomNavigationBarItem (icon: Icon (Icons.chat_sharp), label: 'Belanja'),
   const BottomNavigationBarItem (icon: Icon (Icons.message), label: 'Pesan'),
   ];

  @override
  Widget build(BuildContext context) {
  final bottomNavBar = BottomNavigationBar(
    items: _kBottomNavBarItems,
    currentIndex: _currentTabIndex,
    type: BottomNavigationBarType.fixed,
    onTap: (int index) {
      setState ((){
         _currentTabIndex = index;
      });
    },
 );
    return Scaffold(
      body: _kTabPages[_currentTabIndex],
      bottomNavigationBar: bottomNavBar,
    );
  }
}