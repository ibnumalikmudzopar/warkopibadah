import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);
 
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();


  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text);
    } on FirebaseAuthException catch(e){
      setState(() {
        errorMessage = e.message;
    });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text);
    } on FirebaseAuthException catch(e){
      setState(() {
        errorMessage = e.message;
    });
    }
  }

  Widget _title(){
    return Text('Firebase Auth');
  }

  Widget _entryField(
    String title,
    TextEditingController controller
  ){
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _errorMessage(){
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  Widget _submitButton(){
    return ElevatedButton(
      onPressed: isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword ,
      child: Text(isLogin ? 'login' : 'Register')
    );
  }

  Widget _loginButton(){
    return TextButton(onPressed: (){
      setState((){
        isLogin = !isLogin;
      });
    }, child: Text(isLogin ? 'Register Instead' : 'Login Instead'));
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
            _entryField('email', _controllerEmail),
            _entryField('Password', _controllerPassword),
            _errorMessage(),
            _submitButton(),
            _loginButton(),
          ],
        ),
      ),
    );
  }
}