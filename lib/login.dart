import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth.dart'; // Pastikan Anda memiliki file auth.dart yang diperlukan

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;
  bool rememberMe = false;
  bool _obscureText = true; // Menyembunyikan teks secara default

  final TextEditingController _controllerEmail = TextEditingController(text: 'ibnumalikmudzopar@gmail.com'); // Set email
  final TextEditingController _controllerPassword = TextEditingController(text: 'swgh1551'); // Set password

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      if (rememberMe) {
        // save email and password to shared preferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('email', _controllerEmail.text);
        prefs.setString('password', _controllerPassword.text);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return Text('Firebase Auth');
  }

  Widget _entryField(String title, TextEditingController controller, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscureText : false, // Menyembunyikan teks jika field password
      decoration: InputDecoration(
        labelText: title,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: _togglePasswordVisibility,
              )
            : null,
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(isLogin ? 'Login' : 'Register'),
    );
  }

  Widget _loginButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'Register Instead' : 'Login Instead'),
    );
  }

  Widget _rememberMeCheckbox() {
    return CheckboxListTile(
      title: Text('Remember Me'),
      value: rememberMe,
      onChanged: (value) {
        setState(() {
          rememberMe = value!;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    if (email != null && password != null) {
      setState(() {
        _controllerEmail.text = email;
        _controllerPassword.text = password;
        rememberMe = true;
      });
    }
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
            Text(
              'Welcome To\nAplikasi Manajemen\nWarungKopi Ibadah',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Silahkan Masukan Email & Password',
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
              ),
            ),
            _entryField('Email', _controllerEmail),
            _entryField('Password', _controllerPassword, isPassword: true),
            _rememberMeCheckbox(),
            _errorMessage(),
            _submitButton(),
            _loginButton(),
          ],
        ),
      ),
    );
  }
}



// kode login page inti ini dibawah, kode diatas itu yang otomatis email saya dan password terisi
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'auth.dart'; // Pastikan Anda memiliki file auth.dart yang diperlukan

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   String? errorMessage = '';
//   bool isLogin = true;
//   bool rememberMe = false;
//   bool _obscureText = true; // Menyembunyikan teks secara default

//   final TextEditingController _controllerEmail = TextEditingController();
//   final TextEditingController _controllerPassword = TextEditingController();

//   void _togglePasswordVisibility() {
//     setState(() {
//       _obscureText = !_obscureText;
//     });
//   }

//   Future<void> signInWithEmailAndPassword() async {
//     try {
//       await Auth().signInWithEmailAndPassword(
//         email: _controllerEmail.text,
//         password: _controllerPassword.text,
//       );
//       if (rememberMe) {
//         // save email and password to shared preferences
//         final prefs = await SharedPreferences.getInstance();
//         prefs.setString('email', _controllerEmail.text);
//         prefs.setString('password', _controllerPassword.text);
//       }
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         errorMessage = e.message;
//       });
//     }
//   }

//   Future<void> createUserWithEmailAndPassword() async {
//     try {
//       await Auth().createUserWithEmailAndPassword(
//         email: _controllerEmail.text,
//         password: _controllerPassword.text,
//       );
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         errorMessage = e.message;
//       });
//     }
//   }

//   Widget _title() {
//     return Text('Firebase Auth');
//   }

//   Widget _entryField(String title, TextEditingController controller, {bool isPassword = false}) {
//     return TextField(
//       controller: controller,
//       obscureText: isPassword ? _obscureText : false, // Menyembunyikan teks jika field password
//       decoration: InputDecoration(
//         labelText: title,
//         suffixIcon: isPassword
//             ? IconButton(
//                 icon: Icon(
//                   _obscureText ? Icons.visibility : Icons.visibility_off,
//                 ),
//                 onPressed: _togglePasswordVisibility,
//               )
//             : null,
//       ),
//     );
//   }

//   Widget _errorMessage() {
//     return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
//   }

//   Widget _submitButton() {
//     return ElevatedButton(
//       onPressed: isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
//       child: Text(isLogin ? 'Login' : 'Register'),
//     );
//   }

//   Widget _loginButton() {
//     return TextButton(
//       onPressed: () {
//         setState(() {
//           isLogin = !isLogin;
//         });
//       },
//       child: Text(isLogin ? 'Register Instead' : 'Login Instead'),
//     );
//   }

//   Widget _rememberMeCheckbox() {
//     return CheckboxListTile(
//       title: Text('Remember Me'),
//       value: rememberMe,
//       onChanged: (value) {
//         setState(() {
//           rememberMe = value!;
//         });
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadRememberMe();
//   }

//   _loadRememberMe() async {
//     final prefs = await SharedPreferences.getInstance();
//     final email = prefs.getString('email');
//     final password = prefs.getString('password');
//     if (email != null && password != null) {
//       setState(() {
//         _controllerEmail.text = email;
//         _controllerPassword.text = password;
//         rememberMe = true;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Welcome To\nAplikasi Manajemen\nWarungKopi Ibadah',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 30),
//             Text(
//               'Silahkan Masukan Email & Password',
//               style: TextStyle(
//                 fontSize: 15,
//                 fontStyle: FontStyle.italic,
//               ),
//             ),
//             _entryField('Email', _controllerEmail),
//             _entryField('Password', _controllerPassword, isPassword: true),
//             _rememberMeCheckbox(),
//             _errorMessage(),
//             _submitButton(),
//             _loginButton(),
//           ],
//         ),
//       ),
//     );
//   }
// }
