import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/screen/home_screen.dart';
import 'package:flutter_application_1/screen/login_screen.dart';
import 'package:flutter_application_1/screen/globals.dart' as globals;






class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
with SingleTickerProviderStateMixin{
  @override
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);


  

    Future.delayed(const Duration(seconds:2),(){
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
  if (mounted) {
    if (user != null) {
      tunggu().then((_) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const BottomNavBar(),
        ));
      });
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ));
    }
  }
});
    });;

    
  }

  @override
  void dispose(){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    overlays: SystemUiOverlay.values);
    super.dispose();
  }

  
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return  Scaffold(
      backgroundColor: Colors.black,
      body:Stack(
        children: <Widget>[
          Positioned(
            top:MediaQuery.of(context).viewInsets.top+250,
            left: screenWidth*0.24,
            child:Container(
            decoration: const BoxDecoration(
          color: Colors.black
        ),
        child: Image.asset('assets/images/logo.png',
        width: 200,
        height: 200,)
        ), ),
        const Positioned(
          top: 400,
          left:160,
          child:Text("",style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),)
        )
        ],
      )
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
final CollectionReference _produk = FirebaseFirestore.instance.collection('users');
Future<void> getNamaUser() async {
  FirebaseAuth auth = FirebaseAuth.instance;

  await for (var authState in auth.authStateChanges()) {
    if (authState != null) {
      try {
        DocumentSnapshot userSnapshot = await _produk.doc(authState.uid).get();

        if (userSnapshot.exists) {
          Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
          if (userData.containsKey('name') && userData.containsKey('url')) {
            setState(() {
              globals.nama = userData['name'];
              globals.url = userData['url']; 
            });
          } else {
            print('Kunci \'nama\' tidak ditemukan dalam data user dengan ID ${authState.uid}');
          }
        } else {
          print('Dokumen tidak ditemukan untuk user dengan ID ${authState.uid}');
        }
      } catch (e) {
        print('Error: $e');
      }
      break;
    }
  }
}
Future<void> tunggu() async {
  await getUserID();
  await getNamaUser();
}
}