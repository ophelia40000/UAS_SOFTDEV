import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/comment.dart';
import 'package:flutter_application_1/screen/home_screen.dart';
import 'package:flutter_application_1/screen/pengaturan.dart';
import 'package:flutter_application_1/screen/post_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_application_1/screen/globals.dart' as globals;
import 'package:flutter_application_1/screen/tweet_services.dart';

import '../utils/assets.dart';
class Item {
  bool tombol = false;
  bool tombol1 = false;
  bool tombol3 = false;
  Item();
}

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> with SingleTickerProviderStateMixin {
  late TabController tabCtrl;
  @override
  void initState() {
    super.initState();
    tabCtrl = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    super.dispose();
    tabCtrl.dispose();
  }

  String myVariable = "";
  Color warna = Colors.white;
  bool tombol = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.warna1,
      drawer: const WidgetDrawer(),
      appBar: AppBar(
        backgroundColor: globals.warna1,
        leading: Builder(builder: (context) {
          return GestureDetector(
            onTap: () {
            },
            child: Container(
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
                  globals.url,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }),
        title: Image.asset('assets/images/logo2.png',
        height: 50,
        width: 50,),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: TabBar(
              controller: tabCtrl,
              tabs: const [
                Tab(text: 'Mengikuti'),
                Tab(text: 'Untuk Anda'),
              ],
              labelColor: globals.warna2,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              indicatorColor: Colors.blue,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 3,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Pengaturan()));
            },
            icon: Icon(
              Icons.settings,
              color: globals.warna2,
              size: 25,
            ),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            child: TabBarView(
              controller: tabCtrl,
              children: [
                const PostFire(),
                _Tab(
                  tweets: TweetService.getTweet(),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom+30,
            right :MediaQuery.of(context).viewInsets.right+15,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: const CircleBorder(), 
                  padding: const EdgeInsets.all(14)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const PostScreen()));
              },
              child: const Icon(Icons.add,color: Colors.white,),
            ),
          )
        ],
      ),
    );
  }
}

class _Tab extends StatefulWidget {
  final List<TweetModel> tweets;
  const _Tab({required this.tweets});

  @override
  State<_Tab> createState() => _TabState();
}

class _TabState extends State<_Tab> {
  Color warna = Colors.grey;
  bool tombol = false;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.tweets.length,
      separatorBuilder: (context, index) => const Divider(height: 0),
      itemBuilder: (context, index) => InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.white.withOpacity(0.08),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    widget.tweets[index].verified == 'blue' ? 100 : 10,
                  ),
                  border: Border.all(
                    color: Colors.grey,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    widget.tweets[index].verified == 'blue' ? 100 : 10,
                  ),

                  child: Image.network(
                    widget.tweets[index].FotoPengguna == ''
                        ? 'https://blackscreen.space/images/pro/black-screen_39.png'
                        : widget.tweets[index].FotoPengguna,
                    fit: BoxFit.cover,
                  ),

                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            children: [
                              Flexible(
                                flex: 3,
                                child: Text(
                                  widget.tweets[index].namaPengguna,
                                  style: TextStyle(
                                    color: globals.warna2,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              if (widget.tweets[index].verified != 'no')
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: SvgPicture.asset(
                                    verifiedIcon,
                                    width: 15,
                                    height: 15,
                                    color:
                                        widget.tweets[index].verified == 'blue'
                                            ? Colors.blue
                                            : Colors.yellow,
                                  ),
                                ),
                              Flexible(
                                flex: 2,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    '@${widget.tweets[index].username}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              const Text(
                                '21 jam',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.more_vert_rounded,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.tweets[index].otomatis.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              robotIcon,
                              width: 14,
                              height: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              'Otomatis',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: (widget.tweets[index].body.length > 300)
                                ? '${widget.tweets[index].body.substring(0, 300)}...'
                                : widget.tweets[index].body,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: globals.warna2.withOpacity(0.8),
                            ),
                          ),
                          if (widget.tweets[index].body.length > 300)
                            const TextSpan(
                              text: 'Tampilkan lebih banyak',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (widget.tweets[index].image.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: StaggeredGrid.count(
                          crossAxisCount: 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          children: widget.tweets[index].image.length == 3
                              ? [
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 2,
                                    mainAxisCellCount: 4,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        widget.tweets[index].image[0],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  ...widget.tweets[index].image
                                      .skip(1)
                                      .map(
                                        (e) => StaggeredGridTile.count(
                                          crossAxisCellCount: 2,
                                          mainAxisCellCount: 2,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.asset(
                                              e,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ]
                              : [
                                  ...widget.tweets[index].image.map(
                                    (e) {
                                      final length =
                                          widget.tweets[index].image.length;
                                      return StaggeredGridTile.count(
                                        crossAxisCellCount: length == 1 ? 4 : 2,
                                        mainAxisCellCount: length == 1 ? 4 : 2,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(
                                            e,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ],
                        ),
                      ),
                    if (widget.tweets[index].url.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: AnyLinkPreview(
                          link: widget.tweets[index].url,
                          backgroundColor: Colors.black,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          bodyStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          bodyMaxLines: 2,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 0.08,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconWidget(
                            color: warna,
                            path: commentIcon,
                            text: NumberFormat.compactCurrency(
                              locale: 'id',
                              symbol: '',
                              decimalDigits: 0,
                            ).format(widget.tweets[index].comment.length),
                            onTap: () {
                              print("ayam");
                              setState(() {
                                if (tombol) {
                                  warna = Colors.grey;
                                } else {
                                  warna = Colors.blue;
                                }
                                tombol = !tombol;
                              });
                            },
                          ),
                          IconWidget(
                            path: retweetIcon,
                            color: widget.tweets[index].retweet.contains('user')
                                ? Colors.green
                                : Colors.grey,
                            text: NumberFormat.compactCurrency(
                              locale: 'id',
                              symbol: '',
                              decimalDigits: 0,
                            ).format(widget.tweets[index].retweet.length),
                            onTap: () {
                              setState(() {
                                widget.tweets[index].retweet.contains('user')
                                    ? widget.tweets[index].retweet
                                        .remove('user')
                                    : widget.tweets[index].retweet.add('user');
                              });
                            },
                          ),
                          LikeButton(
                            size: 16,
                            bubblesColor: const BubblesColor(
                              dotPrimaryColor: Colors.white,
                              dotSecondaryColor: Colors.grey,
                            ),
                            circleColor: const CircleColor(
                                start: Colors.white, end: Colors.red),
                            onTap: (isLiked) async {
                              widget.tweets[index].like.contains('user')
                                  ? widget.tweets[index].like.remove('user')
                                  : widget.tweets[index].like.add('user');
                              return !isLiked;
                            },
                            isLiked: widget.tweets[index].like.contains('user'),
                            likeBuilder: (isLiked) {
                              return isLiked
                                  ? SvgPicture.asset(
                                      likeFilledIcon,
                                      color: Colors.red,
                                    )
                                  : SvgPicture.asset(
                                      likeOutlinedIcon,
                                      color: Colors.grey,
                                    );
                            },
                            likeCount: widget.tweets[index].like.length,
                            countBuilder: (likeCount, isLiked, text) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 2.0),
                                child: Text(
                                  NumberFormat.compactCurrency(
                                    locale: 'id',
                                    symbol: '',
                                    decimalDigits: 0,
                                  ).format(widget.tweets[index].like.length),
                                  style: TextStyle(
                                    color: isLiked ? Colors.red : Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconWidget(
                            path: viewsIcon,
                            text: NumberFormat.compactCurrency(
                              locale: 'id',
                              symbol: '',
                              decimalDigits: 0,
                            ).format(widget.tweets[index].view),
                            onTap: () {},
                          ),
                          IconWidget(
                            path: shareIcon,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IconWidget extends StatefulWidget {
  final String path;
  final Color color;
  final String? text;
  final Function() onTap;
  const IconWidget({
    super.key,
    required this.path,
    this.color = Colors.grey,
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
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hover = true;
        });
      },
      onExit: (_) {
        setState(() {
          hover = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          children: [
            SvgPicture.asset(
              widget.path,
              color: hover ? Colors.grey.withOpacity(0.6) : widget.color,
              width: 16,
              height: 16,
            ),
            if (widget.text != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  widget.text!,
                  style: TextStyle(
                    color: hover ? Colors.grey.withOpacity(0.6) : widget.color,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
  

class PostFire extends StatefulWidget {
  const PostFire({super.key});

  @override
  State<PostFire> createState() => _PostFireState();
}

class _PostFireState extends State<PostFire> {
  final CollectionReference _produk =
      FirebaseFirestore.instance.collection('post');
  final List<Item> items = List.generate(1000, (index) => Item());
  final List<String> blockedUsers = []; 
  final List<String> followingUsers = [];
  bool isRestricted = false;

  @override
  void initState() {
    super.initState();
    _loadBlockedUsers();
    _loadFollowingUsers();
    _loadRestrictedMode();
  }

  Future<void> _loadBlockedUsers() async {
    final userBlocked = await FirebaseFirestore.instance
        .collection('users') 
        .doc(globals.uid) 
        .get();
    if (userBlocked.exists) {
      final blockedUsersData = userBlocked.data()!['blocked_users'];
      if (blockedUsersData != null && blockedUsersData is List) {
        setState(() {
          blockedUsers.addAll(blockedUsersData.cast<String>());
        });
      }
    }
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

  Future<void> _loadRestrictedMode() async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(globals.uid).get();
      if (userDoc.exists) {
        setState(() {
          isRestricted = userDoc.data()!['restricted_mode']; 
        });
      }
    } catch (e) {
      print('Gagal memuat restricted mode: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _produk.orderBy('date', descending: true).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              CollectionReference likeCollection =
                  _produk.doc(documentSnapshot.id).collection('like');
              if (blockedUsers.contains(documentSnapshot['uid'])) {
                return SizedBox.shrink(); 
              }
              if (isRestricted) {
                if (documentSnapshot['restricted'] != true) {
                  return SizedBox.shrink();
                }
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          documentSnapshot['url'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Text(
                                        documentSnapshot['name'],
                                        style: TextStyle(
                                          color: globals.warna2,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Spacer(flex:4),
                                    Text(
                                      documentSnapshot['date'].substring(0,16),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          PopupMenuButton<int>(
                          color: Colors.grey[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          onSelected: (item) {
                             if (item == 1) {
                                blockUser(documentSnapshot['uid']);
                               print("block akun");
                            } else if (item == 0) {
                              followUser(documentSnapshot['uid']);
                              print("follow akun");
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem<int>
                            (
                              padding: EdgeInsets.symmetric(horizontal: 10), 
                              height: 30, 
                              value: 0,
                              child: Text(
                                "Follow",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            PopupMenuItem<int>
                            (
                              padding: EdgeInsets.symmetric(horizontal: 10), 
                              height: 30, 
                              value: 1,
                              child: Text(
                                "Block",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            
                          ],
                          child: const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.more_vert_rounded,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                            ],
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: (documentSnapshot['text']),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: globals.warna2.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        (documentSnapshot.data() != null && (documentSnapshot.data() as Map<String, dynamic>).containsKey('image') && documentSnapshot['image'] != null && documentSnapshot['image'] != '')
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: SizedBox(
                              height: 200, 
                              width: double.infinity, 
                              child: Image.network(
                                documentSnapshot['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('post')
                .doc(documentSnapshot.id)
                .collection('comments')
                .snapshots(),
            builder: (context, snapshot) {
              
              int commentCount = snapshot.data?.docs.length ?? 0; 
              return IconWidget(
                path: commentIcon,
                color: items[index].tombol3 ? Colors.green : Colors.grey,
                text: '$commentCount', 
                onTap: () {
                                    setState(() {
                                      
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CommentPage(postId: documentSnapshot.id),
                                        ),
                                      );
                                    });
                                  },
              );
            },
          ),
                                IconWidget(
                                  path: retweetIcon,
                                  color: items[index].tombol1 ? Colors.blue : Colors.grey,
                                  text: '0',
                                  onTap: () {
                                    setState(() {
                                      items[index].tombol1=!items[index].tombol1;
                                    });
                                  },
                                ),
                                StreamBuilder(
                                  stream: likeCollection.snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot>
                                          likeSnapshot) {
                                    if (likeSnapshot.hasData) {
                                      int likeCount =
                                          likeSnapshot.data!.docs.length;
                                      return LikeButton(
                                        onTap: (isLiked) async {
                                          setState(() {
                                            if (items[index].tombol) {
                                              unlikePost(
                                                idPost: documentSnapshot.id);
                                          } else {
                                            LikePost(
                                                idpost: documentSnapshot.id);
                                          }
                                          items[index].tombol=!items[index].tombol;
                                          });
                                          return items[index].tombol;
                                        },
                                        size: 16,
                                        bubblesColor: const BubblesColor(
                                          dotPrimaryColor: Colors.white,
                                          dotSecondaryColor: Colors.grey,
                                        ),
                                        circleColor: const CircleColor(
                                            start: Colors.white,
                                            end: Colors.red),
                                        isLiked: false,
                                        likeBuilder: (isLiked) {
                                          return isLiked
                                              ? SvgPicture.asset(
                                                  likeFilledIcon,
                                                  color: Colors.red,
                                                )
                                              : SvgPicture.asset(
                                                  likeOutlinedIcon,
                                                  color: Colors.grey,
                                                );
                                        },
                                        likeCount: likeCount,
                                        countBuilder:
                                            (likeCount, isLiked, text) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2.0),
                                                child: Text(
                                              '${likeCount}',
                                              style: TextStyle(
                                                color: isLiked
                                                    ? Colors.red
                                                    : Colors.grey,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  },
                                ),
                                IconWidget(
                                  path: viewsIcon,
                                  text: "0",
                                  onTap: () {},
                                ),
                                IconWidget(
                                  path: shareIcon,
                                  onTap: () {},
                                ),
                              ],
                            ),
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
          child: CircularProgressIndicator(),
        );
      },
    );
  }


  Future<void> blockUser(String userId) async {
    try {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(globals.uid);
      await userDoc.update({
        'blocked_users': FieldValue.arrayUnion([userId])
      });
      setState(() {
        blockedUsers.add(userId);
      });
      print('User berhasil diblokir.');
    } catch (e) {
      print('Gagal memblokir pengguna: $e');
    }
  }
  Future followUser(String userId) async {
    try {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(globals.uid);
      await userDoc.update({
        'following_users': FieldValue.arrayUnion([userId])
      });
      setState(() {
        followingUsers.add(userId);
      });
      print('User berhasil diikuti.');
    } catch (e) {
      print('Gagal mengikuti pengguna: $e');
    }
  }

  Future LikePost({required String idpost}) async {
    final docUser = FirebaseFirestore.instance
        .collection('post')
        .doc(idpost)
        .collection('like')
        .doc(globals.uid);

    final json = {
      'like': 'yes',
    };
    await docUser.set(json);
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

