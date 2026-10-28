import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/globals.dart' as globals;
import 'package:flutter_application_1/widgets/safe_image.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController simpanteks = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final CollectionReference _chat;

  @override
  void initState() {
    super.initState();
    _chat = FirebaseFirestore.instance
        .collection('chat_room')
        .doc(globals.chat_room)
        .collection('messages');
  }

  @override
  void dispose() {
    simpanteks.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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
            hapusnotif(
              idPost: globals.chat_room,
              idlawan: globals.uid2,
            );
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: <Widget>[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF272932),
                  width: 1.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SafeNetworkImage(
                  imageUrl: globals.url2,
                  fit: BoxFit.cover,
                  cacheWidth: 80,
                  cacheHeight: 80,
                  fallbackWidget: const Icon(
                    Icons.person,
                    color: Colors.white70,
                    size: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    globals.nama2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  const Row(
                    children: [
                      SizedBox(
                        width: 6,
                        height: 6,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Pesan Langsung",
                        style: TextStyle(
                          color: Color(0xFF8E92A8),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Realtime Message Stream
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _chat.orderBy('waktu', descending: true).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.connectionState ==
                          ConnectionState.waiting &&
                      !streamSnapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white70),
                      ),
                    );
                  }

                  if (!streamSnapshot.hasData ||
                      streamSnapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1B1C22),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFF272932),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.chat_bubble_outline_rounded,
                                color: Color(0xFF8E92A8),
                                size: 26,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Direct Channel Open",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Kirim pesan langsung ke ${globals.nama2}.",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF7A7E85),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final docs = streamSnapshot.data!.docs;

                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot = docs[index];
                      final data =
                          documentSnapshot.data() as Map<String, dynamic>;
                      final bool isMe = data['pengguna'] == globals.nama;
                      final String messageText = data['pesan'] ?? '';

                      if (isMe) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF282A36),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(14),
                                bottomLeft: Radius.circular(14),
                                bottomRight: Radius.circular(4),
                                topRight: Radius.circular(14),
                              ),
                              border: Border.all(
                                color: const Color(0xFF383B48),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              messageText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                height: 1.35,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B1C22),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(14),
                                topRight: Radius.circular(14),
                                bottomRight: Radius.circular(14),
                                bottomLeft: Radius.circular(4),
                              ),
                              border: Border.all(
                                color: const Color(0xFF272932),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              messageText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                height: 1.35,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),

            // Responsive Bottom Input Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF0F1015),
                border: Border(
                  top: BorderSide(
                    color: Color(0xFF1E202B),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B1C22),
                        borderRadius: BorderRadius.circular(23),
                        border: Border.all(
                          color: const Color(0xFF272932),
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: TextField(
                        controller: simpanteks,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Tulis pesan...",
                          hintStyle: TextStyle(
                            color: Color(0xFF8E929E),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            _sendMessage();
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF282A36),
                          Color(0xFF1E202A),
                        ],
                      ),
                      border: Border.all(
                        color: const Color(0xFF383B48),
                        width: 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: _sendMessage,
                        child: const Icon(
                          Icons.send_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final text = simpanteks.text.trim();
    if (text.isEmpty) return;

    notif(chatRoomId: globals.chat_room);
    pesan(globals.chat_room, globals.nama, text);
    simpanteks.clear();
  }

  void pesan(String chatRoomId, String senderId, String messageText) {
    FirebaseFirestore.instance
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'pengguna': senderId,
      'pesan': messageText,
      'waktu': DateTime.now().toString(),
    });
  }

  Future notif({required String chatRoomId}) async {
    final docUser = FirebaseFirestore.instance
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('notif')
        .doc(globals.uid);

    final json = {
      'notif': 'yes',
    };
    await docUser.set(json);
  }

  Future<void> hapusnotif(
      {required String idPost, required String idlawan}) async {
    final docReference = FirebaseFirestore.instance
        .collection('chat_room')
        .doc(idPost)
        .collection('notif')
        .doc(idlawan);

    await docReference.delete();
  }
}