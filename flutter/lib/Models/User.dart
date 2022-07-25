import 'package:flutter/material.dart';

class User {
  late String name, email, token;
  late int id;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        token: json['token']);
  }
}
