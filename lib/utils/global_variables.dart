import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/screens/action_required.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';

const webScreenWidth = 700;

const profileUrl =
    'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg';

String getRoomId(String id1, String id2) {
  if (id1.compareTo(id2) > 0) {
    return id1 + id2;
  }
  return id2 + id1;
}

List<Widget> navigatingList(bool isGuest) {
  final homeScreenItems = [
    const Center(child: FeedScreen()),
    const Center(child: SearchScreen(fromMessage: false)),
    Center(child: isGuest ? const ActionRequired() : const AddPostScreen()),
    const Center(
        child: Text(
      'This Feature is not added yet!',
      style: TextStyle(fontSize: 20),
    )),
    Center(
      child: isGuest
          ? const ActionRequired()
          : ProfileScreen(
              uid: FirebaseAuth.instance.currentUser!.uid,
            ),
    ),

    // const Center(child: SearchScreen(fromMessage: false)),
    // const Center(child: AddPostScreen()),
    // const Center(
    //     child: Text(
    //   'This Feauture is added yet!',
    //   style: TextStyle(fontSize: 20),
    // )),
    // Center(
    //     child: ProfileScreen(
    //   uid: FirebaseAuth.instance.currentUser!.uid,
    // )),
  ];
  return homeScreenItems;
}
