
  


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/splash_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCKRRFyUF4s2Uc5KOHRj1W6ylqIc5UlNz0",
        appId: "1:1009608363850:web:twitter_web",
        messagingSenderId: "1009608363850",
        projectId: "twitter-3ec97",
        storageBucket: "twitter-3ec97.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  await Future.delayed(const Duration(seconds: 0));
  if (!kIsWeb) {
    try {
      FlutterNativeSplash.remove();
    } catch (e) {
      // Ignore
    }
  }
  runApp(
    const MaterialApp(
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

