import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/bloc/instagram_cubit.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  model.User? _user;
  int? _postCount;
  int _following = 0;
  int _followers = 0;
  bool isFollowing = false;
  String? error;

  void _getData() async {
    try {
      var data = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      _user = model.User.fromJson(data.data()!);
      _followers = _user!.followers.length;
      _following = _user!.following.length;
      var posts = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.userId)
          .get();
      isFollowing =
          _user!.followers.contains(FirebaseAuth.instance.currentUser!.uid);
      _postCount = posts.docs.length;
    } catch (e) {
      error = e.toString();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = InstagramCubit.get(context);
    return _user == null
        ? const Center(child: CircularProgressIndicator())
        : error != null
            ? Center(child: Text(error.toString()))
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: mobileBackgroundColor,
                  centerTitle: false,
                  title: Text(cubit.user!.username),
                ),
                body: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 40,
                                backgroundImage:
                                    NetworkImage(cubit.user!.photo),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        itemColumn(_postCount ?? 0, 'posts'),
                                        itemColumn(_followers, 'followers'),
                                        itemColumn(_following, 'following'),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        FirebaseAuth.instance.currentUser!
                                                    .uid ==
                                                widget.userId
                                            ? CustomButton(
                                                bgColor: mobileBackgroundColor,
                                                borderColor: Colors.grey,
                                                textColor: primaryColor,
                                                text: 'Sign Out',
                                                onPressed: () async {
                                                  await cubit.signOut(context);
                                                },
                                              )
                                            : isFollowing
                                                ? CustomButton(
                                                    bgColor: Colors.white,
                                                    borderColor: Colors.black,
                                                    textColor: Colors.grey,
                                                    text: 'Unfollow',
                                                    onPressed: () async {
                                                      setState(() {
                                                        isFollowing = false;
                                                        _followers--;
                                                      });

                                                      await InstagramCubit.get(
                                                              context)
                                                          .followUser(
                                                              _user!.uid);
                                                    },
                                                  )
                                                : CustomButton(
                                                    bgColor: Colors.blue,
                                                    borderColor: Colors.blue,
                                                    textColor: Colors.white,
                                                    text: 'Follow',
                                                    onPressed: () async {
                                                      setState(() {
                                                        isFollowing = true;
                                                        _followers++;
                                                      });

                                                      await InstagramCubit.get(
                                                              context)
                                                          .followUser(
                                                              _user!.uid);
                                                    },
                                                  ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _user!.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _user!.bio,
                            ),
                          ),
                          const Divider(),
                          FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('posts')
                                .where('uid', isEqualTo: widget.userId)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return GridView.builder(
                                // controller: ScrollController(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 1.5,
                                  childAspectRatio: 1,
                                ),
                                shrinkWrap: true,
                                itemCount: _postCount ?? 0,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot snap =
                                      (snapshot.data as dynamic).docs[index];
                                  return Container(
                                    child: Image(
                                      image: NetworkImage(snap['photourl']),
                                      fit: BoxFit.cover,
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
  }

  Widget itemColumn(int count, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
