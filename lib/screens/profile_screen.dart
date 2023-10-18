import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/chat_screen.dart';
import 'package:instagram_clone/screens/edit_profile.dart';
import 'package:instagram_clone/screens/login_screen.dart';
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
  model.User? myId;
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
    final bool isGuest = Provider.of<UserProvider>(context).isGuest;
    if (isGuest) {
      isfollowing = false;
    } else {
      myId = Provider.of<UserProvider>(context).getUser;
      isfollowing ??= userData!['followers'].contains(myId!.uid);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(userData!['username']),
        actions: [
          if (!isGuest && myId?.uid == widget.uid)
            InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text('Are you sure you want log out?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          AuthMethods().logOut();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        child: const Text('Yes'),
                      ),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('No')),
                    ],
                  );
                },
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 20, right: 20),
                child: Text(
                  'Log out',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
        ],
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
                if (userData!['name'] != null)
                  SizedBox(
                    width: 250,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 20, bottom: 4, left: 10),
                      child: Text(
                        userData!['name'],
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                  ),
                if (userData!['bio'] != null)
                  SizedBox(
                    width: 250,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10, left: 10),
                      child: Text(userData!['bio']),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FollowButton(
                      bgColor: !isGuest && myId!.uid == widget.uid
                          ? mobileBackgroundColor
                          : (isfollowing!
                              ? const Color.fromRGBO(40, 40, 40, 1)
                              : Colors.blue),
                      borderColor: isfollowing!
                          ? const Color.fromRGBO(30, 30, 30, 1)
                          : Colors.grey,
                      text: !isGuest && myId!.uid == widget.uid
                          ? 'Edit Profile'
                          : (isfollowing! ? 'Unfollow' : 'Follow'),
                      textcolor: primaryColor,
                      onPressed: !isGuest && myId!.uid == widget.uid
                          ? () async {
                              List<String> updatedData =
                                  await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) => EditProfile(
                                                name: userData!['name'],
                                                bio: userData!['bio'],
                                                uid: myId!.uid,
                                                photoUrl: myId!.photoUrl,
                                              )));
                              setState(() {
                                userData?['name'] = updatedData[0];
                                userData?['bio'] = updatedData[1];
                              });
                            }
                          : () {
                              setState(() {
                                if (!isGuest) {
                                  FirestoreMethods().followUser(
                                      myId!.uid, widget.uid, isfollowing!);
                                  followersLen += isfollowing! ? -1 : 1;
                                  isfollowing = !isfollowing!;
                                } else {
                                  showSnackBar('Login required to follow users',
                                      context);
                                }
                              });
                            },
                    ),
                    FollowButton(
                      bgColor: !isGuest && myId!.uid == widget.uid
                          ? mobileBackgroundColor
                          : const Color.fromRGBO(40, 40, 40, 1),
                      borderColor: !isGuest && myId!.uid == widget.uid
                          ? Colors.grey
                          : const Color.fromRGBO(30, 30, 30, 1),
                      text: !isGuest && myId!.uid == widget.uid
                          ? 'Share Profile'
                          : 'Message',
                      textcolor: primaryColor,
                      onPressed: () {
                        if (!isGuest) {
                          if (myId!.uid != widget.uid) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                      dudeName: userData!['username'],
                                      dudePic: userData!['photoUrl'],
                                    )));
                          } else {
                            showSnackBar(
                                'This feature is not added yet :(', context);
                          }
                        } else {
                          showSnackBar('Login required to message', context);
                        }
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
