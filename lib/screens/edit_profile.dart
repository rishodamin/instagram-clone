import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';

class EditProfile extends StatefulWidget {
  final String name;
  final String bio;
  final String uid;
  final String photoUrl;
  const EditProfile(
      {super.key,
      required this.name,
      required this.bio,
      required this.uid,
      required this.photoUrl});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _nameController.text = widget.name;
    _bioController.text = widget.bio;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Edit Profile'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Name',
                  style: TextStyle(fontSize: 18),
                ),
                TextField(controller: _nameController),
                const SizedBox(height: 30),
                const Text(
                  'Bio',
                  style: TextStyle(fontSize: 18),
                ),
                TextField(
                  controller: _bioController,
                  maxLines: null,
                  maxLength: 40,
                ),
                const SizedBox(height: 50),
                InkWell(
                  onTap: () {
                    showSnackBar('Updating... Stay in the page', context);
                    var userRef = FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.uid);
                    userRef.update({
                      'name': _nameController.text,
                      'bio': _bioController.text,
                    }).then((_) {
                      showSnackBar('Updated succesfuly', context);
                      Navigator.of(context)
                          .pop([_nameController.text, _bioController.text]);
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    child: const Text(
                      'Update',
                      style: TextStyle(fontSize: 18),
                    ),
                    color: const Color.fromRGBO(30, 30, 30, 1),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
