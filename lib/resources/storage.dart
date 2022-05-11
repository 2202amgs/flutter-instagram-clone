import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadeImage({
    required String path,
    required Uint8List data,
    String? postId,
  }) async {
    Reference reference =
        _storage.ref().child(path).child(_auth.currentUser!.uid);
    if (postId != null) {
      reference = reference.child(postId);
    }
    UploadTask uploadTask = reference.putData(data);
    TaskSnapshot snapshot = await uploadTask;

    String url = await snapshot.ref.getDownloadURL();
    return url;
  }
}
