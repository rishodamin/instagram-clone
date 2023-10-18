import 'package:flutter/material.dart';

class ActionRequired extends StatelessWidget {
  const ActionRequired({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Login required to access this Page :)',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
