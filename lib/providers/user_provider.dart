import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  model.User? _user;
  final AuthMethods _authmethods = AuthMethods();

  model.User? get getUser => _user;

  Future<void> refreshUser() async {
    _user = await _authmethods.getUserDetails();
    notifyListeners();
  }
}
