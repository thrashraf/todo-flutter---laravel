import 'package:flutter/material.dart';

class Todo {
  late String task;
  late bool isCheck;

  Todo({required this.task, required this.isCheck});

  void toggleIsCheck() {
    isCheck = !isCheck;
  }

  bool intToBool(int a) => a == 0 ? false : true;
}
