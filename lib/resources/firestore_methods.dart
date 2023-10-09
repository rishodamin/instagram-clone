import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload post
  Future<String> uploadPost(
    String caption,
    Uint8List file,
    String uid,
    String username,
    String? profImage,
  ) async {
    try {
      String photoUrl =
          await StorageMethods().uploadImageStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        caption: caption,
        uid: uid,
        postId: postId,
        username: username,
        datePublished: DateTime.now(),
        profImage: profImage,
        likes: [],
        postUrl: photoUrl,
      );

      // adding to database
      _firestore.collection('posts').doc(postId).set(post.toJson());
      return "success";
    } catch (e) {
      return e.toString();
    }
  }
}
