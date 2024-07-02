import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:warkopibadah/auth.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({ Key? key }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
    final User? user = Auth().currentUser; // get  current user

  Future<void> signOut() async {
    await Auth().signOut();
  }


  Widget _userId(){
    return Text(user?.email ?? 'user email');
  }

  Widget _signOutButton(){
    return ElevatedButton(
      onPressed: signOut,
      child: Text('Sign Out')
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _userId(),
            _signOutButton()
          ],
        ),
      ),
    );
  }
}