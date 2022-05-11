import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/bloc/instagram_cubit.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/comment_card.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;
  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) =>
                CommentCard(snap: snapshot.data!.docs[index]),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          height: kToolbarHeight,
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    NetworkImage(InstagramCubit.get(context).user!.photo),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText:
                          'Comment as ${InstagramCubit.get(context).user!.username}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await InstagramCubit.get(context)
                      .postComment(widget.postId, _controller.text);
                  setState(() {
                    _controller.clear();
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Post',
                    style: TextStyle(
                      color: blueColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
