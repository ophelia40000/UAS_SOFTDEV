import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/chat_screen.dart';
import 'package:flutter_application_1/screen/globals.dart' as globals;
import 'package:flutter_application_1/screen/home_screen.dart';
import 'package:flutter_application_1/widgets/safe_image.dart';

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
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1015),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1015),
        elevation: 0,
        toolbarHeight: 60,
        shape: const Border(
          bottom: BorderSide(
            color: Color(0xFF272932),
            width: 1,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 22,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const BottomNavBar()),
              );
            }
          },
        ),
        centerTitle: true,
        title: const Text(
          "Direct Message",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: userCollection.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting &&
                !streamSnapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                ),
              );
            }

            if (!streamSnapshot.hasData ||
                streamSnapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "Tidak ada pengguna ditemukan",
                  style: TextStyle(
                    color: Color(0xFF7A7E85),
                    fontSize: 14,
                  ),
                ),
              );
            }

            final docs = streamSnapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = docs[index];

                if (documentSnapshot.id == globals.uid) {
                  return const SizedBox.shrink();
                }

                final data = documentSnapshot.data() as Map<String, dynamic>;
                final String userName = data['name'] ?? 'User';
                final String avatarUrl = data['url'] ?? '';
                final String chatRoomId =
                    createChatRoomId(globals.uid, documentSnapshot.id);

                final CollectionReference notifCollection = FirebaseFirestore
                    .instance
                    .collection('chat_room')
                    .doc(chatRoomId)
                    .collection('notif');

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B1C22),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFF272932),
                      width: 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        globals.url2 = avatarUrl.isNotEmpty
                            ? avatarUrl
                            : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4cFqKLnpvsbrxezgbVAojOIRTwmEH2iDSkQ&s';
                        globals.nama2 = userName;
                        globals.uid2 = documentSnapshot.id;
                        globals.chat_room = chatRoomId;

                        hapusnotif(
                          idPost: chatRoomId,
                          idlawan: documentSnapshot.id,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            // Avatar
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF272932),
                                  width: 1.5,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(21),
                                child: SafeNetworkImage(
                                  imageUrl: avatarUrl,
                                  fit: BoxFit.cover,
                                  cacheWidth: 100,
                                  cacheHeight: 100,
                                  fallbackWidget: const Icon(
                                    Icons.person,
                                    color: Colors.white70,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Name & Handle
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "@${userName.toLowerCase().replaceAll(' ', '_')}",
                                    style: const TextStyle(
                                      color: Color(0xFF7A7E85),
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            // Unread Notification Dot
                            StreamBuilder<QuerySnapshot>(
                              stream: notifCollection.snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> notifSnapshot) {
                                if (notifSnapshot.hasData &&
                                    notifSnapshot.data!.docs.isNotEmpty) {
                                  final bool hasUnread = notifSnapshot.data!.docs
                                      .any((doc) => doc.id != globals.uid);
                                  if (hasUnread) {
                                    return Container(
                                      width: 8,
                                      height: 8,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF8F94FB),
                                      ),
                                    );
                                  }
                                }
                                return const SizedBox.shrink();
                              },
                            ),

                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: Color(0xFF7A7E85),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> hapusnotif(
      {required String idPost, required String idlawan}) async {
    final docReference = FirebaseFirestore.instance
        .collection('chat_room')
        .doc(idPost)
        .collection('notif')
        .doc(idlawan);

    try {
      await docReference.delete();
    } catch (e) {
      debugPrint("Error deleting notification: $e");
    }
  }
}