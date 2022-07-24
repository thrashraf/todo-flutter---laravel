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
  bool isLoading = true;
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
      Network().getData('todo/${user["id"]}').then((todo) {
        setState(() {
          print(todo);
        });
      });
    });
  }

  addNewTodo() {
    setState(() {
      todos.add({'title': todoController.text, 'isCheck': false});
      todoController.text = '';
    });
  }

  editTodo(index) {
    var data = todos.elementAt(index);

    setState(() {
      data["title"] = todoController.text;
      data["isCheck"] = todos[index]["isCheck"];
      todoController.text = '';
    });
  }

  checkTodo(index) {
    bool intToBool(int a) => a == 0 ? false : true;

    bool isCheck = intToBool(todos[index]["isCheck"]);
    setState(() {
      todos[index]["isCheck"] = isCheck ? 0 : 1;
    });
  }

  showEditDialog(index) => _dialogBuilder(
      context: context,
      todoController: todoController,
      action: () => editTodo(index),
      mode: 'edit');

  deleteTodo(index) {
    setState(() {
      todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List todos = context.watch<TodoProviders>().todos;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Navbar(),
      appBar: AppBar(
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
      ),
      body: SafeArea(
        child: (Padding(
          padding: EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: isLoading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "What's up ${user["name"]}!",
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Text(
                          ("${context.watch<TodoProviders>().count}"),
                          style: TextStyle(
                              letterSpacing: 3,
                              color: Colors.grey[700],
                              fontSize: 12),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: todos.length,
                          itemBuilder: (context, index) {
                            return CardTodo(
                              todo: todos[index],
                              index: index,
                            );
                          },
                        )
                      ],
                    )
                  : Loading(),
            ),
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _dialogBuilder(
              context: context,
              todoController: todoController,
              action: addNewTodo,
              mode: 'add');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<void> _dialogBuilder(
    {required BuildContext context,
    TextEditingController? todoController,
    required Function action,
    required String mode}) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Stack(
            children: <Widget>[
              Positioned(
                right: -40.0,
                top: -40.0,
                child: InkResponse(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.close),
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
              Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      mode == 'add' ? "Add new todo" : "Edit todo",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: customTextField(
                          placeholder: 'todos',
                          inputType: TextInputType.text,
                          inputController: todoController),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => action(),
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            padding: EdgeInsets.all(12)),
                        child: Text(
                          mode == 'add' ? 'Add' : 'Edit',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
}
