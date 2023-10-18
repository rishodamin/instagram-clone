import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('About'),
          backgroundColor: mobileBackgroundColor,
        ),
        body: const Padding(
          padding: EdgeInsets.only(top: 120, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Thanks for checking out this app. This is an Instagram clone project made by flutter. If you have any feedback, suggestions, queries or if have logged in and want to delete your account from the database, Contact me at daminrisho@gmail.com',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 40),
              Text(
                'The features I wanted to add more are getting notifications from messages and likes and Changing the profile picture. Since they have some complex process, I didn\'t add them.',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ));
  }
}
