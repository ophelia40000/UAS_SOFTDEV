import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/globals.dart' as globals;

class CommentPage extends StatefulWidget {
  final String postId; // Parameter postId ditambahkan

  const CommentPage({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
 
  final List<CommentData> comments = [];
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    _fetchComments(widget.postId);
  }

  Future<void> _fetchComments(String postId) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('post')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      comments.clear();
      snapshot.docs.forEach((doc) {
        comments.add(CommentData(
          author: doc['author'],
          content: doc['content'],
        ));
      });
    });
  }

  Future<void> _addComment(String postId, String author, String content) async {
    await FirebaseFirestore.instance
        .collection('post')
        .doc(postId)
        .collection('comments')
        .add({
      'author': author,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(), 
    });
    _commentController.clear(); 
    _fetchComments(postId); 
    print(globals.komen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Komentar'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return CommentItem(
                    author: comments[index].author,
                    content: comments[index].content,
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.grey[900],
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Tulis komentar...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      
                      _addComment(
                        widget.postId, 
                        globals.nama, 
                        _commentController.text,
                      );
                      globals.komen=_commentController.text.toString();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentData {
  final String author;
  final String content;

  CommentData({required this.author, required this.content});
}

class CommentItem extends StatelessWidget {
  final String author;
  final String content;

  CommentItem({required this.author, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            author,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            content,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}