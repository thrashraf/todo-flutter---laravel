import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:task/Models/Todo.dart';
import 'dart:collection';

import 'package:task/network_utils/api.dart';

class TodoProviders extends ChangeNotifier {
  List<Todo> todos = [];

  int _count = 1;
  int get count => _count;

  UnmodifiableListView<Todo> get allTasks => UnmodifiableListView(todos);

  addNewTodo(Todo todo) async {
    dynamic user = await Network().getUserName('_user');
    Map userData = jsonDecode(user);
    Map data = {'task': todo.task, 'user_id': userData["id"]};
    print(data);
    Network().createTodo(data).then((data) {
      todos.add(todo);
      notifyListeners();
    });
  }

  getTodo(Todo todo) {
    todos.add(todo);
    notifyListeners();
  }

  editTodo(Todo oldTodo, newTodo) {
    int index = todos.indexOf(oldTodo);

    var updatedTodo = {'task': newTodo.task, 'isCheck': newTodo.isCheck};

    Network().updateTodo(oldTodo.id, updatedTodo).then((res) {
      print(newTodo.runtimeType);
      todos[index] = newTodo;
      notifyListeners();
    });
  }

  checkTodo(index, id, task) {
    print(id);
    var updatedTodo = {'task': task, 'isCheck': 1};
    Network().updateTodo(id, updatedTodo).then((res) {
      todos[index].toggleIsCheck();
      print(todos[0].isCheck);
      notifyListeners();
    });
  }

  deleteTodo(Todo todo) async {
    Network().delete(todo.id).then((res) {
      print(todo.id);
      todos.remove(todo);
      notifyListeners();
    });
  }
}
