import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:instagram_clone/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  //sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
    required String name,
  }) async {
    if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
      var userSnap = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      int userLen = userSnap.docs.length;
      if (userLen > 0) {
        return 'Username already exists';
      }
      try {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        List<String> storageData = await StorageMethods()
            .uploadImageStorage('profilePics', file, false);
        String photoUrl = storageData[0];

        model.User user = model.User(
          email: email,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          username: username,
          password: password,
          name: name,
          bio: bio,
          followers: [],
          following: [],
        );

        // add user to our database
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        return 'succes';
      } catch (e) {
        return e.toString();
      }
    }
    return 'First three Fields have to be fill';
  }

  // login user
  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        return 'succes';
      } catch (e) {
        return e.toString();
      }
    }
    return 'Some fields have to be fill';
  }

  Future<void> logOut() async {
    _auth.signOut();
  }
}
