import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:task/Models/Todo.dart';
import 'package:task/network_utils/api.dart';
import 'package:task/providers/TodoProviders.dart';
import 'package:task/screen/Loading.dart';
import 'package:task/widgets/CardTodo.dart';
import 'package:task/widgets/Dialog.dart';
import 'package:task/widgets/Navbar.dart';
import 'package:task/widgets/custom_textField.dart';

import '../widgets/Skeleton.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map user = {};
  bool isLoading = false;
  List todos = [];

  TextEditingController todoController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Network().getUserName('_user').then((userData) {
      setState(() {
        user = jsonDecode(userData!);
      });
      String id = user["id"].toString();
      Network().requestTodo(id).then((todoData) {
        todoData.forEach((todo) {
          Provider.of<TodoProviders>(context, listen: false).getTodo(Todo(
              task: todo['task'], isCheck: todo['isCheck'], id: todo["id"]));
        });

        setState(() {
          isLoading = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List todos = context.watch<TodoProviders>().todos;

    final Todo newTodo = Todo(task: todoController.text, isCheck: 0);

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Navbar(),
      appBar: Bar(),
      body: SafeArea(
        child: (Padding(
          padding: EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: isLoading ? Content(todos, newTodo) : const Loading(),
            ),
          ),
        )),
      ),
      floatingActionButton: floatingButton(context),
    );
  }

  //? floating button widget
  FloatingActionButton floatingButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showDialog(
          builder: (context) => DialogWidget(
                mode: 'add',
                todo: Todo(task: '', isCheck: 0),
              ),
          context: context),
      backgroundColor: Colors.blue,
      child: const Icon(Icons.add),
    );
  }

  //? body content widget
  Column Content(List<dynamic> todos, Todo newTodo) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What's up ${user["name"]}!",
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 40,
        ),
        Text(
          ("TODAY TASK"),
          style: TextStyle(
              letterSpacing: 3, color: Colors.grey[700], fontSize: 12),
        ),
        const SizedBox(
          height: 20,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: todos.length,
          itemBuilder: (context, index) {
            return CardTodo(
                todo: todos[index],
                index: index,
                todoController: todoController,
                newTodo: newTodo);
          },
        )
      ],
    );
  }

  //? AppBar widget
  AppBar Bar() {
    return AppBar(
      title: Text('test'),
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.grey[500]),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search_outlined),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.notifications_outlined),
        ),
      ],
    );
  }
}
