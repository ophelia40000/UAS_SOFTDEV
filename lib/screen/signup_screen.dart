

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/auth_services.dart';
import 'package:flutter_application_1/screen/home_screen.dart';
import 'package:flutter_application_1/screen/globals.dart' as globals;
import 'package:flutter_application_1/screen/login_screen.dart';

import 'dart:math';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuthService _auth=FirebaseAuthService();
  TextEditingController _username=TextEditingController();
  TextEditingController _email=TextEditingController();
  TextEditingController _password=TextEditingController();

  void dispose(){
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body:Stack(
        children: <Widget>[
          Positioned(
            top: 40,
            left: 0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: globals.warna1,
                shape: CircleBorder(),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
              },
              child: Icon(Icons.arrow_back,color: globals.warna2,),
            )
          ),
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
              left:screenWidth*0.13,
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(
                  color: globals.warna1,
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
              left:screenWidth*0.13,
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
                  _signUp();
                },
                child: const Text(
              "SignUp",
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
  void _signUp() async{

    String email=_email.text;
    String password=_password.text;

    User? user=await _auth.signUpWithEmailAndPassword(email, password);

    if(user!=null){
      await getUserID();
      String generateRandomName() {
      var random = Random();
      int randomNumber = random.nextInt(10000);
      return 'user_$randomNumber';
  }
      globals.nama=generateRandomName();
      globals.url='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4cFqKLnpvsbrxezgbVAojOIRTwmEH2iDSkQ&s';
      print("succed");
      final docUser=FirebaseFirestore.instance.collection('users').doc(globals.uid);
    

    final json={
      'name' :globals.nama,
      'url' : globals.url,
      'restricted_mode': false

    };
    await docUser.set(json);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavBar()));
      
    }
    else{
      print("error");
      _showErrorDialog("Format email salah / Email telah digunakan. Silahkan coba lagi.");
    }
  }
  void _showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 139, 135, 135),
        title: Text("SignUp Gagal"),
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
  
}


