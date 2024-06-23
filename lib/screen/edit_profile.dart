import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/globals.dart' as globals;
import 'package:flutter_application_1/screen/profile.dart';
import 'package:image_picker/image_picker.dart';
class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  FirebaseAuth auth=FirebaseAuth.instance;
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  File? file;
  ImagePicker image = ImagePicker();
  var url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:globals.warna1 ,
      appBar: AppBar(
        backgroundColor: globals.warna1,
        leading: IconButton(
          onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Edit Profile"),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: globals.warna1
            ),
            onPressed: () {
              
            },
            child: Text("Simpan"),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.black,
              child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Container(
                  height: 110,
                  width:MediaQuery.of(context).size.width,
                  color: Colors.blue,
                  child: file == null
                      ? IconButton(
                          icon: Icon(
                            Icons.add_a_photo,
                            size: 30,
                            color: globals.warna2,
                          ),
                          onPressed: () {
                            
                          },
                        )
                      : MaterialButton(
                          height: 100,
                          child: Image.file(
                            file!,
                            fit: BoxFit.cover,
                          ),
                          onPressed: () {
                            
                          },
                        ))
            ),
            Positioned(
              top: 150,
              left: 10,
              child: Text("Nama",style: TextStyle(
                color: Color.fromARGB(255, 218, 209, 209)
              ),),
            ),
            Positioned(
              top: 70,
              left: 10,
              child: Container(
                  height: 70,
                  width:70,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle
                  ),
                  child: file == null
                      ? IconButton(
                          icon: Icon(
                            Icons.add_a_photo,
                            size: 30,
                            color: globals.warna2,
                          ),
                          onPressed: () {
                            getImage();
                          },
                        )
                      : MaterialButton(
                          height: 100,
                          child: Image.file(
                            file!,
                            fit: BoxFit.cover,
                          ),
                          onPressed: () {
                            getImage();
                          },
                        ))
            ),
            Positioned(
              top: 175,
              width:MediaQuery.of(context).size.width,
              child:TextField(
              style: TextStyle(
                color: Colors.white,
              ),
              controller: name,
              decoration: InputDecoration(
                filled: true,
                fillColor: globals.warna3,
                hintText: 'Username',
              ),
            ),
            ),
          ],
        ),
            )
        ],
        
      ),
    );
  }
    getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  uploadFile() async {
    try {
      var imagefile = FirebaseStorage.instance
          .ref()
          .child("contact_photo")
          .child("/${name.text}.jpg");
      UploadTask task = imagefile.putFile(file!);
      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();
      setState(() {
        url = url;
      });
      if (url != null) {
      
      await FirebaseFirestore.instance
          .collection('users') 
          .doc(auth.currentUser!.uid).set 
          ({
            'name': name.text,
            'url': url,
          });

          globals.nama=name.text;
          globals.url=url;

        Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}