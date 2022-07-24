import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:task/Models/User.dart';

class UserProvider extends ChangeNotifier {
  final List<User> userData = [];

  addUser(User user) {
    userData.add(user);
    notifyListeners();
  }
}
