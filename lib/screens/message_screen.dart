import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/chat_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';
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
        padding: EdgeInsets.symmetric(horizontal: 21, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Messages',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
            ),
            const SizedBox(height: 24),
            ListTile(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ChatScreen())),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(profileUrl),
                radius: 28,
              ),
              title: Text(
                'some_user',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              horizontalTitleGap: 24,
              contentPadding: EdgeInsets.all(2),
            ),
            const SizedBox(height: 24),
            ListTile(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ChatScreen())),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(profileUrl),
                radius: 28,
              ),
              title: Text(
                'some_user',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              horizontalTitleGap: 24,
              contentPadding: EdgeInsets.all(2),
            ),
          ],
        ),
      ),
    );
  }
}
