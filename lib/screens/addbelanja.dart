import"package:flutter/material.dart";

class Addbelanja extends StatefulWidget {
  const Addbelanja({ Key? key }) : super(key: key);

  @override
  _AddbelanjaState createState() => _AddbelanjaState();
}

class _AddbelanjaState extends State<Addbelanja> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("add belanja"),
      ),
    );
  }
}