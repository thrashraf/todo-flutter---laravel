import 'package:flutter/cupertino.dart';
import 'package:task/Models/Todo.dart';
import 'dart:collection';

class TodoProviders extends ChangeNotifier {
  final List<Todo> todos = [];

  int _count = 1;
  int get count => _count;

  UnmodifiableListView<Todo> get allTasks => UnmodifiableListView(todos);

  addNewTodo(Todo todo) {
    todos.add(todo);
    notifyListeners();
  }

  editTodo(int index, Todo todo) {
    todos[index] = todo;
    notifyListeners();
  }

  checkTodo(index) {
    todos[index].toggleIsCheck();
    print(todos[0].isCheck);
    notifyListeners();
  }

  deleteTodo(Todo todo) {
    todos.remove(todo);
    notifyListeners();
  }
}
