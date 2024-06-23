
  


import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/splash_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';





Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Future.delayed(const Duration(seconds: 0));
  FlutterNativeSplash.remove();
  runApp( MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        
      ),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

