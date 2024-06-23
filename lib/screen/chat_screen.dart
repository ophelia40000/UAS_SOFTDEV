import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/globals.dart' as globals;
import 'package:flutter_application_1/screen/user.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final simpanteks=TextEditingController();
  final CollectionReference _chat =FirebaseFirestore.instance.collection('chat_room').doc(globals.chat_room).collection('messages');
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: globals.warna1,
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Container(
          width: 30,
          height: 30,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              globals.url2,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(globals.nama2,style: TextStyle(
          color: Colors.white
        ),)
          ],
        ),
        
        backgroundColor: globals.warna1,
        leading: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: globals.warna1,
            shape: CircleBorder(),
          ),
          onPressed: () {
            hapusnotif(
              idPost: globals.chat_room,
              idlawan: globals.uid2,
            );
            Navigator.push(context, MaterialPageRoute(builder: (context)=>user()));
          },
          child: Icon(
            Icons.arrow_back,
            color: globals.warna2,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height:screenHeight-150,
              color: globals.warna1,
              child:StreamBuilder(
                stream:  _chat.orderBy('waktu', descending: true).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
                  if(streamSnapshot.hasData){
                    return ListView.builder(
                      reverse: true,
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                      if(documentSnapshot['pengguna']==globals.nama){
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Card(
                            color: const Color.fromARGB(255, 87, 165, 230),
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.0),
                              bottomLeft: Radius.circular(12.0),
                              bottomRight: Radius.circular(12.0),
                              ),
                            ),
                            child:Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(documentSnapshot['pesan'],style: TextStyle(),),
                            ),
                          ),
                        );
                      }
                      else{
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12.0),
                              bottomLeft: Radius.circular(12.0),
                              bottomRight: Radius.circular(12.0),
                              ),
                            ),
                            child:Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(documentSnapshot['pesan']),
                            ),
                          ),
                        );
                      }
                      }
                    );
                    
                  }
                  return CircularProgressIndicator();
                },
              )

            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width:MediaQuery.of(context).size.width, 
              height: 50, 
              decoration: BoxDecoration(
                color: globals.warna3,
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child:  TextField(
                controller: simpanteks,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  hintText: "   Masukkan Pesan",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 1,
            right: MediaQuery.of(context).viewInsets.right+2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Color.fromARGB(255, 117, 166, 206),
              ),
              onPressed: () {
                setState(() {
                  notif(chatRoomId: globals.chat_room);
                  pesan(globals.chat_room, globals.nama,simpanteks.text);
                  simpanteks.clear();
                  FocusScope.of(context).requestFocus(FocusNode());
                  });
              },
              child: Icon(Icons.send),
            ),
          ),
        ],
      ),
    );
  }
  void pesan(String chatRoomId, String senderId, String messageText) {
  FirebaseFirestore.instance.collection('chat_room').doc(chatRoomId).collection('messages').add({
    'pengguna': senderId,
    'pesan': messageText,
    'waktu': DateTime.now().toString(),
  });
  print("fungsi terpanggil");
}

Future notif({required String chatRoomId}) async {
  final docUser = FirebaseFirestore.instance.collection('chat_room').doc(chatRoomId).collection('notif').doc(globals.uid);


    final json = {
      'notif': 'yes',
    };
    await docUser.set(json);
  }
  Future<void> hapusnotif({required String idPost,required String idlawan}) async {
    final docReference = FirebaseFirestore.instance
        .collection('chat_room')
        .doc(idPost)
        .collection('notif')
        .doc(idlawan);

    await docReference.delete();
  }
}