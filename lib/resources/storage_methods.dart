import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // adding image to the firebase storage
  Future<List<String>> uploadImageStorage(
      String childName, Uint8List file, bool isPost) async {
    String id = '';
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);
    if (isPost) {
      id = const Uuid().v1();
      ref = ref.child(id);
    }
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    if (isPost) {
      return [downloadUrl, id];
    }
    return [downloadUrl];
  }

  Future<void> deletePost(String id) async {
    _storage
        .ref()
        .child('posts')
        .child(_auth.currentUser!.uid)
        .child(id)
        .delete();
  }
}
