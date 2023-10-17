import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String password;
  final String bio;
  final List followers;
  final List following;
  final String name;

  const User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.password,
    required this.bio,
    required this.followers,
    required this.following,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'uid': uid,
        'bio': bio,
        'followers': followers,
        'following': following,
        'photoUrl': photoUrl,
        'password': password,
        'name': name,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      email: snapshot['email'],
      uid: snapshot['uid'],
      photoUrl: snapshot['photoUrl'],
      username: snapshot['username'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
      password: snapshot['password'],
      name: snapshot['name'],
    );
  }
}
