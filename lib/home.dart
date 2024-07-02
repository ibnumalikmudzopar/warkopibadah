// Package untuk Firebase Firestore
import 'package:flutter/material.dart'; // Package dasar dari Flutter
import 'package:warkopibadah/bottomnavigation.dart';
import 'widget/appbar.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Warkop Ibadah'),
      body: BottomNavigation()
      // bottomNavigationBar: const BottomNavigationbar()
    );
  }
}