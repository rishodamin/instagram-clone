import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/chat_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          user.username,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: mobileBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        const SearchScreen(fromMessage: true))),
                child: Card(
                  shadowColor: Colors.grey,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: primaryColor, width: 0.6)),
                  margin: const EdgeInsets.only(bottom: 30),
                  color: mobileBackgroundColor,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 12),
                    child: const Text('Search users to Chat',
                        style: TextStyle(fontSize: 17, color: Colors.grey)),
                  ),
                ),
              ),
            ),
            const Text(
              'Messages',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('messages')
                      .where('owners', arrayContains: user.username)
                      .orderBy('lastMessage', descending: true)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
                        snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> room = data[index].data();
                        room['owners'].remove(user.username);
                        String dudeName = room['owners'][0];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: ListTile(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                          dudeName: dudeName,
                                          dudePic: room[dudeName],
                                        ))),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(room[dudeName]),
                              radius: 28,
                            ),
                            title: Text(
                              dudeName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 19),
                            ),
                            horizontalTitleGap: 24,
                            contentPadding: const EdgeInsets.all(2),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
