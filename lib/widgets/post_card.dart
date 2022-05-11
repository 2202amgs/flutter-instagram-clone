import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/bloc/instagram_cubit.dart';
import 'package:instagram_clone/screens/comments_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  const PostCard({Key? key, required this.snap}) : super(key: key);

  final snap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentsLength = 0;

  @override
  void initState() {
    getComments();
    super.initState();
  }

  void getComments() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentsLength = snapshot.docs.length;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          // HEADER SECTION
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: MediaQuery.of(context).size.width > 600
                    ? webBackgroundColor
                    : mobileBackgroundColor,
              ),
              color: mobileBackgroundColor,
            ),
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['avatar']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat.yMMMd()
                              .format(
                                widget.snap['date'].toDate(),
                              )
                              .toString(),
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            'Delete',
                          ]
                              .map(
                                (e) => InkWell(
                                  onTap: () async {
                                    await InstagramCubit.get(context)
                                        .deletePost(widget.snap['postId']);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 18,
                                    ),
                                    child: Text(e),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          // IMAGE SECTION
          GestureDetector(
            onDoubleTap: () async {
              await InstagramCubit.get(context)
                  .likePost(widget.snap['postId'], widget.snap['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.37,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['photourl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    ),
                    isAnimated: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          // LIKE AND COMMENT SECTION
          Row(
            children: [
              LikeAnimation(
                isAnimated: widget.snap['likes']
                    .contains(InstagramCubit.get(context).user!.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await InstagramCubit.get(context)
                        .likePost(widget.snap['postId'], widget.snap['likes']);
                  },
                  icon: widget.snap['likes']
                          .contains(InstagramCubit.get(context).user!.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_outline,
                        ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          CommentsScreen(postId: widget.snap['postId']),
                    ),
                  );
                },
                icon: const Icon(Icons.comment_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.bookmark),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: widget.snap['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text: ' ',
                        ),
                        TextSpan(
                          text: widget.snap['desc'],
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'View all $commentsLength comments',
                      style:
                          const TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(
                            widget.snap['date'].toDate(),
                          )
                          .toString(),
                      style:
                          const TextStyle(fontSize: 16, color: secondaryColor),
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
}
