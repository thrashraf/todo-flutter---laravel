import 'package:flutter/material.dart';

class User {
  late String name, email, token;
  late int id;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.token});
}
