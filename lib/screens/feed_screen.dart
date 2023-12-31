import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/main.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/info_screen.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/message_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/post_card.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    final bool isGuest = Provider.of<UserProvider>(context).isGuest;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          if (isGuest)
            Padding(
              padding: const EdgeInsets.only(top: 16, right: 8),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LoginScreen()));
                },
                child: const Text(
                  'Leave',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
            ),
          SizedBox(width: width > webScreenWidth ? 100 : 0),
          IconButton(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const InfoScreen())),
            icon: const Icon(Icons.info_outline),
          ),
          SizedBox(width: width > webScreenWidth ? 100 : 0),
          IconButton(
            onPressed: () {
              if (!isGuest) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MessageScreen()));
              } else {
                showSnackBar(
                    'Login required to access the Message page', context);
              }
            },
            icon: const Icon(Icons.messenger_outline),
          ),
          SizedBox(width: width > webScreenWidth ? 100 : 0),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => Padding(
              padding: width > webScreenWidth
                  ? EdgeInsets.symmetric(horizontal: width / 3)
                  : const EdgeInsets.symmetric(horizontal: 0),
              child: PostCard(snap: snapshot.data!.docs[index].data()),
            ),
          );
        },
      ),
    );
  }
}
