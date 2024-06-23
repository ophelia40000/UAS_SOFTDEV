import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/home_screen.dart';
import 'package:flutter_application_1/screen/globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool _togglebutton = false; 
  final simpanteks = TextEditingController();
  XFile? _pickedImage; 

  void _toggle() {
    setState(() {
      _togglebutton = !_togglebutton;
    });
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    _pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => BottomNavBar()));
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => BottomNavBar()));
                  globals.ayam = simpanteks.text;
                  globals.ikan = 130;
                  globals.x = 1;
                  createUser(
                    name: globals.ayam,
                    imageUrl: _pickedImage != null ? _pickedImage!.path : null,
                    restricted: _togglebutton, 
                  );
                });
              },
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  margin: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  width: 110,
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Post",
                      style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  )),
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 500,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        child: TextField(
                          controller: simpanteks,
                          textAlignVertical: TextAlignVertical.top,
                          expands: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 50, top: 10),
                            hintText: "What's happening?",
                            hintStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.black,
                            border: InputBorder.none,
                          ),
                          maxLines: null,
                          minLines: null,
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Icon(
                            Icons.person_2_rounded,
                            color: Color.fromARGB(123, 0, 0, 0),
                            size: 40,
                          ),
                        ),
                      ),
                      if (_pickedImage != null)
                      Positioned(
                        top: 140, 
                        left: 0,  
                        child: SizedBox(
                          height: 350, 
                          width: 380, 
                          child: Image.file(
                            File(_pickedImage!.path),
                            fit: BoxFit.cover, 
                          ),
                        ),
                      ),    
                    ],
                  ),
                ),
              ],
            ),
            
            Container(
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10)),
              child: InkWell(
                child: Row(
                  children: [
                    Icon(
                      _togglebutton ? Icons.circle_outlined : Icons.circle,
                      color: Colors.white,
                    ),
                    const Text(
                      " Konten Dewasa",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                onTap: () {
                  _toggle();
                  print("object");
                },
              ),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: _getImageFromGallery, 
                    icon: const Icon(
                      Icons.add_photo_alternate,
                      color: Colors.blue,
                      size: 45,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.gif_box_outlined,
                      color: Colors.blue,
                      size: 45,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.list_alt,
                      color: Colors.blue,
                      size: 45,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.room_outlined,
                      color: Colors.blue,
                      size: 45,
                    )),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.blue,
                          size: 45,
                        )),
                  ),
                ),
            
              ],
            ),
            
          ],
        ),
      ),
    );
  }

   Future<void> createUser({required String name, required String? imageUrl, required bool restricted}) async { // Perhatikan String? di sini
  final docUser = FirebaseFirestore.instance.collection('post').doc();


  if (imageUrl != null) {
    final storageReference = FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    try {
      await storageReference.putFile(File(imageUrl)); 
      final downloadUrl = await storageReference.getDownloadURL();

      await docUser.set({
        'name': globals.nama,
        'text': name,
        'date': DateTime.now().toString(),
        'url': globals.url,
        'uid': globals.uid,
        'blocked_users': [],
        'image': downloadUrl, 
        'restricted': !restricted 
      });
    } catch (e) {
      print("Error uploading image: $e");
    }
  } else {
   
    await docUser.set({
      'name': globals.nama,
      'text': name,
      'date': DateTime.now().toString(),
      'url': globals.url,
      'uid': globals.uid,
      'blocked_users': [],
      'restricted': !restricted 
    });
  }
}
}