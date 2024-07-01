import 'package:flutter/material.dart';

class Belanja extends StatefulWidget {
  const Belanja({ Key? key }) : super(key: key);

  @override
  _BelanjaState createState() => _BelanjaState();
}

class _BelanjaState extends State<Belanja> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Belanja'),
    ));
  }
}