import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
    if (!kIsWeb) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    }


  

    Future.delayed(const Duration(seconds: 2), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (mounted) {
          if (user != null) {
            tunggu().then((_) {
              if (mounted) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => const BottomNavBar(),
                ));
              }
            });
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            ));
          }
        }
      });
    });

    
  }

  @override
  void dispose(){
    if (!kIsWeb) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: SystemUiOverlay.values);
    }
    super.dispose();
  }

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 180,
          height: 180,
          fit: BoxFit.contain,
        ),
      ),
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
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;
          String name = (userData['name'] ??
                  userData['username'] ??
                  userData['nama'] ??
                  userData['email']?.toString().split('@').first ??
                  '')
              .toString();
          String url = (userData['url'] ??
                  userData['photoUrl'] ??
                  userData['avatar'] ??
                  userData['imageUrl'] ??
                  userData['foto'] ??
                  '')
              .toString();

          if (mounted) {
            setState(() {
              if (name.isNotEmpty) globals.nama = name;
              if (url.isNotEmpty) globals.url = url;
            });
          }
        } else {
          debugPrint('Dokumen tidak ditemukan untuk user dengan ID ${authState.uid}');
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