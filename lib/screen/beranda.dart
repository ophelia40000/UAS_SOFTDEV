import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/comment.dart';
import 'package:flutter_application_1/screen/pengaturan.dart';
import 'package:flutter_application_1/screen/post_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_application_1/screen/globals.dart' as globals;
import '../utils/assets.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1015),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1015),
        elevation: 0,
        toolbarHeight: 64,
        shape: const Border(
          bottom: BorderSide(
            color: Color(0xFF272932),
            width: 1,
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          alignment: Alignment.center,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF272932),
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                globals.url.isNotEmpty
                    ? globals.url
                    : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4cFqKLnpvsbrxezgbVAojOIRTwmEH2iDSkQ&s',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.person,
                  color: Colors.white70,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        title: Image.asset(
          'assets/images/logo.png',
          height: 52,
          width: 52,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16),
            alignment: Alignment.center,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Pengaturan()),
                );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1B1C22),
                  border: Border.all(
                    color: const Color(0xFF272932),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.settings_outlined,
                  color: Color(0xFFC0C4CC),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          // ── Subtle Top Right Ambient Glow ──
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0x8C262038),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Realtime Posts Feed ──
          const PostFire(),

          // ── Primary Floating Action Button ──
          Positioned(
            bottom: 24,
            right: 20,
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF282A36),
                    Color(0xFF1E202A),
                  ],
                ),
                border: Border.all(
                  color: const Color(0xFF383B48),
                  width: 1.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x66000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PostScreen(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Interactive IconWidget ──
class IconWidget extends StatefulWidget {
  final String path;
  final Color color;
  final String? text;
  final VoidCallback onTap;

  const IconWidget({
    super.key,
    required this.path,
    this.color = const Color(0xFF7A7E85),
    this.text,
    required this.onTap,
  });

  @override
  State<IconWidget> createState() => _IconWidgetState();
}

class _IconWidgetState extends State<IconWidget> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    final activeColor = hover ? Colors.white : widget.color;

    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                widget.path,
                colorFilter: ColorFilter.mode(activeColor, BlendMode.srcIn),
                width: 18,
                height: 18,
              ),
              if (widget.text != null) ...[
                const SizedBox(width: 6),
                Text(
                  widget.text!,
                  style: TextStyle(
                    color: activeColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Realtime Feed (Firestore Posts) ──
class PostFire extends StatefulWidget {
  const PostFire({super.key});

  @override
  State<PostFire> createState() => _PostFireState();
}

class _PostFireState extends State<PostFire> {
  final CollectionReference _postsCollection =
      FirebaseFirestore.instance.collection('post');
  final List<String> blockedUsers = [];

  @override
  void initState() {
    super.initState();
    _loadBlockedUsers();
  }

  Future<void> _loadBlockedUsers() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(globals.uid)
          .get();
      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null && data.containsKey('blocked_users')) {
          final blockedData = data['blocked_users'];
          if (blockedData is List) {
            setState(() {
              blockedUsers.addAll(blockedData.cast<String>());
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error load blocked users: $e');
    }
  }

  String _formatPostDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '';
    if (rawDate.length >= 16) {
      return rawDate.substring(0, 16);
    }
    return rawDate;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _postsCollection.orderBy('date', descending: true).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          final docs = streamSnapshot.data!.docs;

          // Filter out blocked users
          final filteredDocs = docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final uid = data['uid'] ?? '';
            return !blockedUsers.contains(uid);
          }).toList();

          if (filteredDocs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF1B1C22),
                        border: Border.all(
                          color: const Color(0xFF272932),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.dynamic_feed_rounded,
                        color: Color(0xFFC0C4CC),
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      "Belum Ada Postingan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Jadilah yang pertama untuk membagikan sesuatu di Shadow Post!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF7A7E85),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF282A36),
                            Color(0xFF1E202A),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF383B48),
                          width: 1,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x4D000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PostScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: const Text(
                          "Buat Postingan",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: filteredDocs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot = filteredDocs[index];
              final data = documentSnapshot.data() as Map<String, dynamic>;

              final String postName = data['name'] ?? 'User';
              final String postDate = _formatPostDate(data['date']?.toString());
              final String postText = data['text'] ?? '';
              final String postUrl = data['url'] ?? '';
              final String? postImage = data['image'];
              final bool hasImage =
                  postImage != null && postImage.toString().trim().isNotEmpty;

              final CollectionReference likeCollection =
                  _postsCollection.doc(documentSnapshot.id).collection('like');

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1C22),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF272932),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header: Avatar, Name, Handle, Date, More Menu ──
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                            child: Image.network(
                              postUrl.isNotEmpty
                                  ? postUrl
                                  : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4cFqKLnpvsbrxezgbVAojOIRTwmEH2iDSkQ&s',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.person,
                                color: Colors.white70,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      postName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (postDate.isNotEmpty) ...[
                                    const SizedBox(width: 6),
                                    Text(
                                      "•  $postDate",
                                      style: const TextStyle(
                                        color: Color(0xFF7A7E85),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "@${postName.toLowerCase().replaceAll(' ', '_')}",
                                style: const TextStyle(
                                  color: Color(0xFF7A7E85),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Popup Menu
                        PopupMenuButton<int>(
                          color: const Color(0xFF1E1E24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: const BorderSide(
                              color: Color(0xFF272932),
                              width: 1,
                            ),
                          ),
                          onSelected: (item) {
                            if (item == 1) {
                              blockUser(data['uid'] ?? '');
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem<int>(
                              value: 1,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.block_outlined,
                                    color: Colors.redAccent,
                                    size: 18,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Block",
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.more_horiz_rounded,
                              size: 20,
                              color: Color(0xFF7A7E85),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ── Post Text ──
                    if (postText.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        postText,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.45,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],

                    // ── Post Image ──
                    if (hasImage) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 280),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFF272932),
                              width: 1,
                            ),
                          ),
                          child: Image.network(
                            postImage,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 14),

                    // ── Actions Row: Comment & Like (Realtime Firestore) ──
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Color(0xFF272932),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Comment Action
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('post')
                                .doc(documentSnapshot.id)
                                .collection('comments')
                                .snapshots(),
                            builder: (context, commentSnap) {
                              final int commentCount =
                                  commentSnap.data?.docs.length ?? 0;
                              return IconWidget(
                                path: commentIcon,
                                text: '$commentCount',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CommentPage(
                                        postId: documentSnapshot.id,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),

                          const SizedBox(width: 28),

                          // Like Action with Firestore Sync
                          StreamBuilder<QuerySnapshot>(
                            stream: likeCollection.snapshots(),
                            builder: (context, likeSnapshot) {
                              final int likeCount =
                                  likeSnapshot.data?.docs.length ?? 0;
                              final bool isUserLiked = likeSnapshot.hasData &&
                                  likeSnapshot.data!.docs
                                      .any((doc) => doc.id == globals.uid);

                              return LikeButton(
                                onTap: (currentLiked) async {
                                  if (isUserLiked) {
                                    await unlikePost(
                                      idPost: documentSnapshot.id,
                                    );
                                  } else {
                                    await likePost(
                                      idpost: documentSnapshot.id,
                                    );
                                  }
                                  return !currentLiked;
                                },
                                size: 18,
                                bubblesColor: const BubblesColor(
                                  dotPrimaryColor: Colors.white,
                                  dotSecondaryColor: Colors.grey,
                                ),
                                circleColor: const CircleColor(
                                  start: Colors.white,
                                  end: Color(0xFFFF3366),
                                ),
                                isLiked: isUserLiked,
                                likeBuilder: (liked) {
                                  return SvgPicture.asset(
                                    liked ? likeFilledIcon : likeOutlinedIcon,
                                    colorFilter: ColorFilter.mode(
                                      liked
                                          ? const Color(0xFFFF3366)
                                          : const Color(0xFF7A7E85),
                                      BlendMode.srcIn,
                                    ),
                                    width: 18,
                                    height: 18,
                                  );
                                },
                                likeCount: likeCount,
                                countBuilder: (count, liked, text) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                      '$likeCount',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: liked
                                            ? const Color(0xFFFF3366)
                                            : const Color(0xFF7A7E85),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }

        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
          ),
        );
      },
    );
  }

  Future<void> blockUser(String userId) async {
    if (userId.isEmpty) return;
    try {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(globals.uid);
      await userDoc.update({
        'blocked_users': FieldValue.arrayUnion([userId])
      });
      setState(() {
        blockedUsers.add(userId);
      });
    } catch (e) {
      debugPrint('Gagal memblokir pengguna: $e');
    }
  }


  Future<void> likePost({required String idpost}) async {
    final docUser = FirebaseFirestore.instance
        .collection('post')
        .doc(idpost)
        .collection('like')
        .doc(globals.uid);

    await docUser.set({
      'like': 'yes',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> unlikePost({required String idPost}) async {
    final docReference = FirebaseFirestore.instance
        .collection('post')
        .doc(idPost)
        .collection('like')
        .doc(globals.uid);

    await docReference.delete();
  }
}
