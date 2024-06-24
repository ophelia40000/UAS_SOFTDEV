import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/chat_screen.dart';
import 'package:flutter_application_1/screen/globals.dart' as globals;
import 'package:flutter_application_1/screen/home_screen.dart';

String createChatRoomId(String userId1, String userId2) {
  List<String> userIds = [userId1, userId2];
  userIds.sort(); 
  return userIds.join('_');
}
class user extends StatefulWidget {
  const user({super.key});

  @override
  State<user> createState() => _userState();
}

class _userState extends State<user> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference user = FirebaseFirestore.instance.collection('users');
  final List<String> followingUsers = [];

  @override
  void initState() {
    super.initState();
    _loadFollowingUsers(); 
  }

  Future<void> _loadFollowingUsers() async {
    final userFollowing = await FirebaseFirestore.instance
        .collection('users') 
        .doc(globals.uid) 
        .get();
    if (userFollowing.exists) {
      final followingUsersData = userFollowing.data()!['following_users'];
      if (followingUsersData != null && followingUsersData is List) {
        setState(() {
          followingUsers.addAll(followingUsersData.cast<String>());
        });
      }
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
            shape: CircleBorder(),
            elevation: 0,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavBar()));
          },
          child: Icon(Icons.arrow_back,color: globals.warna2,),
        ),
        title: Text("Direct Message",style: TextStyle(
          color: Colors.white
        ),),
      ),
      body:StreamBuilder(
        stream: user.snapshots(),
        builder: (context, AsyncSnapshot <QuerySnapshot> streamSnapshot){
          if(streamSnapshot.hasData){
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index){
                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                final CollectionReference notif =FirebaseFirestore.instance.collection('chat_room').doc(createChatRoomId(globals.uid, documentSnapshot.id)).collection('notif');
      
                if (documentSnapshot.id == globals.uid || !followingUsers.contains(documentSnapshot.id)) {
                  return SizedBox(); 
                } else {
                  return Container(
                    height: 50,
                    color: globals.warna1,
                    child: ElevatedButton (
                      style: ElevatedButton.styleFrom(
                        backgroundColor: globals.warna1
                      ),
                      onPressed: () {
                        globals.url2=documentSnapshot['url'];
                        globals.nama2=documentSnapshot['name'];
                        globals.uid2=documentSnapshot.id;
                        globals.chat_room=createChatRoomId(globals.uid, documentSnapshot.id);
                        hapusnotif(
                          idPost: createChatRoomId(globals.uid, documentSnapshot.id),
                          idlawan: documentSnapshot.id
                        );
                        print(globals.chat_room);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen()));
                      },
                      child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 0,
                          left: -10,
                          child:Container(
                            width: 30,
                            height: 30,
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: Colors.grey,
                              width: 2,
                              ),
                            ),
                            child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(documentSnapshot['url']
                              ,fit: BoxFit.cover,),
                              )           ,
                            ),
                        ),
                        Positioned(
                          top: 15,
                          left: 40,
                          child: Text(documentSnapshot['name'],style: TextStyle(
                            color: globals.warna2
                          ),),
                        ),
                        Positioned(
                          top: 20,
                          right: 0,
                          child: StreamBuilder(
    stream: notif.snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> notifSnapshot) {
      if (notifSnapshot.hasData) {
        if (notifSnapshot.data!.docs.isNotEmpty) {
          bool hasUnreadNotif = notifSnapshot.data!.docs.any((doc) => doc.id != globals.uid);
          if (hasUnreadNotif) {
            return Text('!');
          }
        }
      }
      return SizedBox(); 
    },
  ),
                        )
                      ],
                    )
                    )
                  );
                }
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      ),
    );
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