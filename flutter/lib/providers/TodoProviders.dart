import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:task/Models/Todo.dart';
import 'dart:collection';

import 'package:task/network_utils/Auth.dart';
import 'package:task/network_utils/Todo.dart';

class TodoProviders extends ChangeNotifier {
  List<Todo> todos = [];

  int _count = 1;
  int get count => _count;

  UnmodifiableListView<Todo> get allTasks => UnmodifiableListView(todos);

  addNewTodo(Todo todo) async {
    dynamic user = await Auth().getLocalItem('_user');
    Map userData = jsonDecode(user);
    Map data = {'task': todo.task, 'user_id': userData["id"]};
    print(data);
    TodoApi().createTodo(data).then((data) {
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
    print(id);
    var updatedTodo = {'task': task, 'isCheck': 1};
    TodoApi().updateTodo(id, updatedTodo).then((res) {
      todos[index].toggleIsCheck();
      print(todos[0].isCheck);
      notifyListeners();
    });
  }

  deleteTodo(Todo todo) async {
    TodoApi().delete(todo.id).then((res) {
      print(todo.id);
      todos.remove(todo);
      notifyListeners();
    });
  }
}
