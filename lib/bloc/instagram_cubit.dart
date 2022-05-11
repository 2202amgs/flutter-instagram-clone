// ignore_for_file: slash_for_doc_comments

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/bloc/instagram_states.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/post_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';
import 'package:uuid/uuid.dart';
import '../models/post.dart';
import '../resources/storage.dart';
import '../utils/utils.dart';

class InstagramCubit extends Cubit<InstagrameStates> {
  InstagramCubit() : super(InstagramInitialState());

  static InstagramCubit get(context) => BlocProvider.of(context);
/**
 * user method
 * v1
 * created by samir ammar
 */
  model.User? user;

  void getUserData() {
    if (FirebaseAuth.instance.currentUser!.uid.isNotEmpty) {
      emit(GetProfileLoadingState());
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then(
        (value) {
          if (value.exists) {
            user = model.User.fromJson(value.data()!);
          }
          emit(GetProfileSuccessState());
        },
      ).catchError(
        (err) {
          emit(GetProfileErrorState(err));
        },
      );
    }
  }

  // bottom navigationbar
  List<Widget> pages = [
    const FeedScreen(),
    const SearchScreen(),
    const PostScreen(),
    const Center(child: Icon(Icons.favorite)),
    ProfileScreen(userId: FirebaseAuth.instance.currentUser!.uid),
  ];

  PageController pageController = PageController();
  int currentIndex = 0;

  void pageChange(int index) {
    pageController.jumpToPage(index);
    currentIndex = index;
    emit(PageChangeState());
  }

/**
 * Post screen methods
 * v1
 * created by samir ammar
 */

  // post image
  Uint8List? postImage;
  selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create a post'),
          children: [
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                postImage = await pickImage(ImageSource.camera);
                emit(PostImagChangeState());
              },
              padding: const EdgeInsets.all(20.0),
              child: const Text('Take a photo'),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
              },
              padding: const EdgeInsets.all(20.0),
              child: const Text('Cansel'),
            ),
          ],
        );
      },
    );
  }

  // upload post
  Future<void> uploadPost({
    required String desc,
  }) async {
    emit(PostUploadLoadingState());
    String postId = const Uuid().v1();
    try {
      String photourl = await Storage().uploadeImage(
        path: 'post',
        data: postImage!,
        postId: postId,
      );
      Post post = Post(
        postId: postId,
        username: user!.username,
        desc: desc,
        uid: user!.uid,
        avatar: user!.photo,
        photourl: photourl,
        date: DateTime.now(),
        likes: [],
      );
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .set(post.toJson());
      emit(PostUploadSuccessState());
    } catch (err) {
      emit(PostUploadErrorState(err.toString()));
    }
    postImage = null;
  }

  // like post
  Future<void> likePost(String postId, List likes) async {
    try {
      if (likes.contains(user!.uid)) {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .update({
          'likes': FieldValue.arrayRemove([user!.uid]),
        });
      } else {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .update({
          'likes': FieldValue.arrayUnion([user!.uid]),
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // comment post
  Future<void> postComment(String postId, String text) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'uid': user!.uid,
          'profilePic': user!.photo,
          'mame': user!.username,
          'commentId': commentId,
          'text': text,
          'date': DateTime.now(),
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // delete post
  Future<void> deletePost(String postId) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e);
    }
  }

  // profile
  Future<void> followUser(String followingId) async {
    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      List following = (snap.data() as dynamic)['following'];
      if (following.contains(followingId)) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({
          'following': FieldValue.arrayRemove([followingId]),
        });
        await FirebaseFirestore.instance
            .collection('users')
            .doc(followingId)
            .update({
          'followers': FieldValue.arrayRemove([user!.uid]),
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({
          'following': FieldValue.arrayUnion([followingId]),
        });
        await FirebaseFirestore.instance
            .collection('users')
            .doc(followingId)
            .update({
          'followers': FieldValue.arrayUnion([user!.uid]),
        });
      }
    } catch (e) {}
  }

  Future<void> signOut(context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } catch (e) {}
  }
}
