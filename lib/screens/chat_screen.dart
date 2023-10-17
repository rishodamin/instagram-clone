import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String dudeName;
  final String dudePic;
  const ChatScreen({
    super.key,
    required this.dudeName,
    required this.dudePic,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User myId = Provider.of<UserProvider>(context).getUser!;
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.dudePic),
            radius: 20,
          ),
          title: Text(
            widget.dudeName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
          ),
          horizontalTitleGap: 14,
          contentPadding: EdgeInsets.all(0),
        ),
        backgroundColor: mobileBackgroundColor,
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: TextField(
                  controller: messageController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Message...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                FirestoreMethods().sendMessage(
                    messageController.text,
                    myId.username,
                    widget.dudeName,
                    myId.photoUrl,
                    widget.dudePic);
                messageController.text = '';
              },
              child: const Text(
                'Send',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .doc(getRoomId(myId.username, widget.dudeName))
            .collection('Room')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
              snapshot.data!.docs;
          return ListView.builder(
            reverse: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> message = data[index].data();
              return Row(
                mainAxisAlignment: message['sender'] == myId.username
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: message['sender'] == myId.username
                          ? Colors.purple
                          : const Color.fromRGBO(40, 40, 40, 1),
                    ),
                    constraints: const BoxConstraints(maxWidth: 220),
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      message['message'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
