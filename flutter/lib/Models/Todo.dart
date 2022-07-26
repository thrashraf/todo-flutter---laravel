import 'package:flutter/material.dart';

class Todo {
  late String task;
  late int isCheck;
  int? id;

  Todo({required this.task, required this.isCheck, this.id});

  intToBool() {
    return isCheck != 1 ? false : true;
  }

  toggleIsCheck() {
    isCheck = isCheck == 0 ? 1 : 0;
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      task: json['task'],
      isCheck: json['isCheck'],
    );
  }
}
