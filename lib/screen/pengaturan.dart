import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/globals.dart' as globals;
import 'package:flutter_application_1/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screen/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import cloud_firestore

class Pengaturan extends StatefulWidget {
  const Pengaturan({super.key});

  @override
  State<Pengaturan> createState() => _Pengaturan();
}

class _Pengaturan extends State<Pengaturan> {
  final CollectionReference users = FirebaseFirestore.instance.collection('users'); 
  bool isRestricted = false; // Variabel untuk melacak status restricted mode

  @override
  void initState() {
    super.initState();
    _loadRestrictedMode(); // Memuat status restricted mode saat aplikasi dimulai
  }

  Future<void> _loadRestrictedMode() async {
  try {
    final userDoc = await users.doc(FirebaseAuth.instance.currentUser!.uid).get();
    if (userDoc.exists) {
      setState(() {
        isRestricted = (userDoc.data() as Map<String, dynamic>)['restricted_mode']; 
      });
    }
  } catch (e) {
    print('Gagal memuat restricted mode: $e');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.warna1,
      appBar: AppBar(
        backgroundColor: globals.warna1,
        leading: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: globals.warna1,
            shape: const CircleBorder(),
            elevation: 0,
            padding: const EdgeInsets.all(12),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const BottomNavBar()));
          },
          child: Icon(Icons.arrow_back,color: globals.warna2,),
        ),
        centerTitle: true,
        title: Text("Pengaturan",style: TextStyle(
          color: globals.warna2,
        ),), 
    
      ),
      body: ListView(
        children:<Widget> [
          Container(
            height: 50,
            color: globals.warna1,
            child:Stack(
              children: <Widget>[
                Positioned(
                  top: 12,
                  left: 10,
                  child: Text("Restricted Mode",style: TextStyle(
                    fontSize: 20,
                    color: globals.warna2,
                  ),),
                ),
                Positioned(
                  left: 300,
                  top: 0,
                  child: Switch(
            value: isRestricted, 
            activeColor: Colors.white,
            onChanged: (value) async { 
              setState(() {
                // Toggle isRestricted: 
                isRestricted = !isRestricted; // Toggle restricted status
                // ... (Kode untuk mengubah warna jika diperlukan)
              });

              // Update restricted mode status di Firestore
              await updateRestrictedMode(isRestricted);
            },
          ),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            color: globals.warna1,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 155,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        signOut();
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                      });
                    },
                    child: Text("LogOut",style: TextStyle(
                      color: Colors.white
                    ),),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}


Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    print("Logout berhasil");
  } catch (e) {
    print("Error saat logout: $e");
  }
}

// Fungsi untuk memperbarui restricted mode status di Firestore
Future<void> updateRestrictedMode(bool isRestricted) async {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  try {
    await users.doc(FirebaseAuth.instance.currentUser!.uid).update({
      'restricted_mode': isRestricted, // Nama field di Firestore
    });
    print('Restricted mode berhasil diperbarui.');
  } catch (e) {
    print('Gagal memperbarui restricted mode: $e');
  }
}