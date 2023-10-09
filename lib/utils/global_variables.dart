import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feed_screen.dart';

const webScreenWidth = 600;
const homeScreenItems = [
  Center(child: FeedScreen()),
  Center(child: Text('Search')),
  Center(child: AddPostScreen()),
  Center(child: Text('Notifications')),
  Center(child: Text('Profile')),
];
const profileUrl =
    'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg';
