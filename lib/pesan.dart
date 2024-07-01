import 'package:flutter/material.dart';

class Pesan extends StatefulWidget {
  const Pesan({ Key? key }) : super(key: key);

  @override
  _PesanState createState() => _PesanState();
}

class _PesanState extends State<Pesan> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Pesan", style: TextStyle(fontSize: 30),)
    );
  }
}