import 'package:flutter/material.dart';
import 'package:warkopibadah/home.dart';
import 'package:warkopibadah/login.dart';
import 'auth.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({ super.key });

  @override
  _WidgetTreeState createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData){
          return const Home(title: 'Warkop Ibadah',);
        } else {
          return const LoginPage();
        }
      }
    );
  }
}