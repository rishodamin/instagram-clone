import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/follow_button.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? postData;
  User? myId;
  bool? isfollowing;
  int followingLen = 0;
  int followersLen = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      setState(() {
        userData = userSnap.data();
        postData = postSnap.docs;
        followersLen = (userData!['followers'] as List).length;
        followingLen = (userData!['following'] as List).length;
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null || postData == null) {
      return const Center(child: CircularProgressIndicator());
    }
    myId = Provider.of<UserProvider>(context).getUser;
    isfollowing ??= userData!['followers'].contains(myId!.uid);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(userData!['username']),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(userData!['photoUrl']),
                      radius: 40,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            profileStats(postData!.length.toString(), 'posts'),
                            profileStats(
                              followersLen.toString(),
                              'followers',
                            ),
                            profileStats(
                              followingLen.toString(),
                              'following',
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 250,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(userData!['bio']),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FollowButton(
                      bgColor: myId!.uid == widget.uid
                          ? mobileBackgroundColor
                          : (isfollowing!
                              ? const Color.fromRGBO(40, 40, 40, 1)
                              : Colors.blue),
                      borderColor: isfollowing!
                          ? const Color.fromRGBO(30, 30, 30, 1)
                          : Colors.grey,
                      text: myId!.uid == widget.uid
                          ? 'Edit Profile'
                          : (isfollowing! ? 'Unfollow' : 'Follow'),
                      textcolor: primaryColor,
                      onPressed: myId!.uid == widget.uid
                          ? () {}
                          : () {
                              setState(() {
                                FirestoreMethods().followUser(
                                    myId!.uid, widget.uid, isfollowing!);
                                followersLen += isfollowing! ? -1 : 1;
                                isfollowing = !isfollowing!;
                              });
                            },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          GridView.builder(
            shrinkWrap: true,
            itemCount: postData!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 1.5,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return Image(
                image: NetworkImage(postData![index]['postUrl']),
                fit: BoxFit.cover,
              );
            },
          ),
        ],
      ),
    );
  }

  Column profileStats(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
        ),
      ],
    );
  }
}
