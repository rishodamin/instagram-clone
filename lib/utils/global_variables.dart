import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';

const webScreenWidth = 600;
final homeScreenItems = [
  const Center(child: FeedScreen()),
  const Center(child: SearchScreen()),
  const Center(child: AddPostScreen()),
  const Center(
      child: Text(
    'This Feauture is added yet!',
    style: TextStyle(fontSize: 20),
  )),
  Center(
      child: ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  )),
];
const profileUrl =
    'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg';
