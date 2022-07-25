import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:task/Models/Todo.dart';
import 'dart:collection';

import 'package:task/network_utils/api.dart';

class TodoProviders extends ChangeNotifier {
  final List<Todo> todos = [];

  int _count = 1;
  int get count => _count;

  UnmodifiableListView<Todo> get allTasks => UnmodifiableListView(todos);

  addNewTodo(Todo todo) async {
    dynamic user = await Network().getUserName('_user');
    Map userData = jsonDecode(user);
    Map data = {'task': todo.task, 'user_id': userData["id"]};
    print(data);
    Network().createTodo('createTodo', data).then((data) {
      todos.add(todo);
      notifyListeners();
    });
  }

  getTodo(Todo todo) {
    todos.add(todo);
    notifyListeners();
  }

  editTodo(Todo oldTodo, Todo newTodo) {
    int index = todos.indexOf(oldTodo);

    Network().updateTodo('updateTodo/${index}',
        {'task': newTodo.task, 'isCheck': newTodo.isCheck}).then((res) {
      todos[index] = newTodo;
      notifyListeners();
    });
  }

  checkTodo(index) {
    todos[index].toggleIsCheck();
    print(todos[0].isCheck);
    notifyListeners();
  }

  deleteTodo(Todo todo) async {
    Network().delete('deleteTodo/${todo.id}').then((res) {
      print(todo.id);
      todos.remove(todo);
      notifyListeners();
    });
  }
}
