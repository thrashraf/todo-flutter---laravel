import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:task/Models/Todo.dart';
import 'dart:collection';

import 'package:task/network_utils/Auth.dart';
import 'package:task/network_utils/Todo.dart';

import '../network_utils/Notification.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TodoProviders extends ChangeNotifier {
  List<Todo> todos = [];

  int _count = 1;
  int get count => _count;
  late final service = Notifications();

  UnmodifiableListView<Todo> get allTasks => UnmodifiableListView(todos);

  addNewTodo(Todo todo, dateTime) async {
    dynamic user = await Auth().getLocalItem('_user');
    Map userData = jsonDecode(user);
    Map data = {'task': todo.task, 'user_id': userData["id"]};
    print(data);
    TodoApi().createTodo(data).then((data) async {
      //check if dateTime not empty, then will schedule notification
      if (dateTime != null) {
        await service.scheduleNotification(
            id: data["data"]["id"],
            title: 'Reminder',
            body: todo.task,
            dateTime: dateTime);
      }

      todos.add(
          Todo(task: todo.task, isCheck: todo.isCheck, id: data["data"]["id"]));

      notifyListeners();
    });
  }

  getTodo(Todo todo) async {
    todos.add(todo);
    notifyListeners();
  }

  editTodo(Todo oldTodo, newTodo) {
    int index = todos.indexOf(oldTodo);

    var updatedTodo = {'task': newTodo.task, 'isCheck': newTodo.isCheck};

    TodoApi().updateTodo(oldTodo.id, updatedTodo).then((res) {
      print(newTodo.runtimeType);
      todos[index] = newTodo;
      notifyListeners();
    });
  }

  checkTodo(index, id, task) {
    var updatedTodo = {'task': task, 'isCheck': 1};
    TodoApi().updateTodo(id, updatedTodo).then((res) async {
      //cancel notification
      await FlutterLocalNotificationsPlugin().cancel(id);
      todos[index].toggleIsCheck();
      notifyListeners();
    });
  }

  deleteTodo(Todo todo) async {
    int? id = todo.id;
    TodoApi().delete(todo.id).then((res) async {
      //cancel notification
      await FlutterLocalNotificationsPlugin().cancel(id!);
      todos.remove(todo);
      notifyListeners();
    });
  }
}
