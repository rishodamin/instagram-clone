import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(profileUrl),
            radius: 20,
          ),
          title: Text(
            'some_user',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
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
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Message...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: const Text(
                'Send',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
