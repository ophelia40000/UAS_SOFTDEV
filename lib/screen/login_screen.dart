import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/auth_services.dart';
import 'package:flutter_application_1/screen/home_screen.dart';
import 'package:flutter_application_1/screen/signup_screen.dart';
import 'package:flutter_application_1/screen/globals.dart' as globals;

import 'dart:math';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuthService _auth=FirebaseAuthService();
  TextEditingController _username=TextEditingController();
  TextEditingController _email=TextEditingController();
  TextEditingController _password=TextEditingController();
  final CollectionReference _produk = FirebaseFirestore.instance.collection('users');


  void dispose(){
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body:Stack(
        children: <Widget>[
           Positioned(
            top: MediaQuery.of(context).viewInsets.top+150,
            left:screenWidth*0.23,
            child:Image.asset(
              "assets/images/logo.png",
              width: 200,
              height: 200,
            ),
            
            ),
            Positioned(
              top: MediaQuery.of(context).viewInsets.top+360,
              left:screenWidth*0.1,
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child:  TextField(
                  controller: _email,
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                hintText: "   Email",
                border: InputBorder.none,
              ),
            ),
              ),
            ),
            
            Positioned(
              top: MediaQuery.of(context).viewInsets.top+410,
              left:screenWidth*0.1,
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child:  TextField(
                  obscureText: true,
                  controller: _password,
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                hintText: "   Password",
                border: InputBorder.none,
              ),
            ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).viewInsets.top+540,
              left: MediaQuery.of(context).viewInsets.left+245,
              child: TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                },
                child: Text(
                  "register.",
                  style: TextStyle(
                    color: Color.fromARGB(255, 100, 110, 196),
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: Color.fromARGB(255, 100, 110, 196), 
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).viewInsets.top+540,
              left: MediaQuery.of(context).viewInsets.left+48,
              child: TextButton(
                onPressed: (){},
                child: Text("Don't have an account? Please ",style: TextStyle(
                  color: Colors.grey,
                ),),
              ),
            ),
            
            Positioned(
              top: MediaQuery.of(context).viewInsets.top+470,
              left: screenWidth*0.25,
              child:
              TextButton(
                style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(const Size(180, 0)),
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color.fromARGB(255, 71, 71, 71)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                )),
                onPressed: () {
                  setState(() {
                    tunggu();
                  });
                },
                child: const Text(
              "Login",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
                ),
              )
            ),
        ],
      ),
    );
  }
  void _signIn() async{

    String email=_email.text;
    String password=_password.text;

    User? user=await _auth.signInWithEmailAndPassword(email, password);

    if(user!=null){
      print("succed");
    }
    else{
      print("Failed");
    _showErrorDialog("Email atau Password salah. Silahkan coba lagi.");
    }
  }

  Future<void> getUserID() async {
  FirebaseAuth auth = FirebaseAuth.instance;

  await for (var authState in auth.authStateChanges()) {
    if (authState != null) {
      globals.uid = authState.uid;
      print("User ID: ${globals.uid}");
      break;
    }
  }
}
String _generateRandomName() {
    final random = Random(); 
    const List<String> prefixes = ['Anon', 'User', 'Guest', 'Visitor'];
    const List<String> suffixes = ['123', '456', '789', 'abc', 'def'];
    return '${prefixes[random.nextInt(prefixes.length)]}${suffixes[random.nextInt(suffixes.length)]}';
  }

  Future<void> getNamaUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await for (var authState in auth.authStateChanges()) {
      if (authState != null) {
        try {
          
          String randomName = _generateRandomName();

         
          globals.nama = randomName;

          
          await _produk.doc(authState.uid).update({'name': randomName});
          print('Nama random "${randomName}" dibuat dan disimpan.');

        } catch (e) {
          print('Error: $e');
        }
        break;
      }
    }
  }

Future<void> tunggu() async {
   _signIn();
  await getUserID();
  await getNamaUser();
  Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavBar()));
}

void _showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 139, 135, 135),
        title: Text("Login Gagal"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}



}