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
    String profImage,
  ) async {
    try {
      List<String> storageData =
          await StorageMethods().uploadImageStorage('posts', file, true);
      String photoUrl = storageData[0];
      String storageId = storageData[1];
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
          storageId: storageId);

      // adding to database
      _firestore.collection('posts').doc(postId).set(post.toJson());
      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> likePost(String postId, String uid, bool isLiked,
      {bool fromHeart = false}) async {
    try {
      if (isLiked) {
        if (fromHeart) {
          _firestore.collection('posts').doc(postId).update({
            'likes': FieldValue.arrayRemove([uid])
          });
        }
      } else {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
          'likes': [],
        });
      } else {
        print('text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likeComment(
      String postId, String commentId, String uid, bool isLiked) async {
    try {
      if (isLiked) {
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // delete post
  Future<void> deletePost(String postId, String storageId) async {
    try {
      _firestore.collection('posts').doc(postId).delete();
      StorageMethods().deletePost(storageId);
    } catch (e) {
      print(e.toString());
    }
  }

  //follow user
  Future<void> followUser(
    String uid,
    String followId,
    bool isfollowing,
  ) async {
    try {
      if (isfollowing) {
        _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
