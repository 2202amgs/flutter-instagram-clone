import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/resources/storage.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUp({
    required String userName,
    required String email,
    required String bio,
    required String password,
    required Uint8List img,
  }) async {
    String response = 'pls, put all data';

    try {
      if (userName.isNotEmpty &&
          email.isNotEmpty &&
          bio.isNotEmpty &&
          password.isNotEmpty &&
          img.isNotEmpty) {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String url = await Storage().uploadeImage(path: 'profile', data: img);
        await _firestore.collection('users').doc(user.user!.uid).set({
          'uid': user.user!.uid,
          'email': email,
          'username': userName,
          'bio': bio,
          'followers': [],
          'following': [],
          'photo': url,
        });
        response = 'success';
      }
    } catch (e) {
      response = e.toString();
    }
    return response;
  }

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    String response = '';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      }
    } catch (e) {
      response = e.toString();
    }
    return response;
  }
}
