import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task/network_utils/api.dart';
import 'package:task/widgets/custom_textField.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map user = {};

  List todos = [
    {'title': 'lol', 'isCheck': true},
    {'title': 'lol 2', 'isCheck': true},
    {'title': 'lol 3', 'isCheck': true}
  ];

  TextEditingController todoController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Network().getUserName('_user').then((value) {
      setState(() {
        user = jsonDecode(value!);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: (Padding(
          padding: EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "What's up ${user["name"]}!",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  // FloatingActionButton(
                  //   onPressed: () {},
                  //   child: Text('+'),
                  // )
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "TODAY'S TASK",
                    style: TextStyle(
                        letterSpacing: 3,
                        color: Colors.grey[700],
                        fontSize: 12),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                          key: UniqueKey(),
                          endActionPane: ActionPane(
                            motion: DrawerMotion(),
                            children: [
                              SlidableAction(
                                // An action can be bigger than the others.
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                label: 'Edit',
                                onPressed: (BuildContext context) {
                                  _dialogBuilder(
                                      context: context,
                                      todoController: todoController,
                                      action: () => editTodo(index));
                                },
                              ),
                              SlidableAction(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                                onPressed: (BuildContext context) {
                                  setState(() {
                                    todos.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[200]),
                            child: CheckboxListTile(
                              title: Text(
                                todos[index]["title"],
                                style: TextStyle(
                                    decoration: todos[index]["isCheck"]
                                        ? TextDecoration.lineThrough
                                        : null),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (bool? value) {
                                setState(() {
                                  todos[index]["isCheck"] =
                                      !todos[index]["isCheck"];
                                });
                              },
                              activeColor: Colors.blue,
                              checkboxShape: CircleBorder(),
                              side: BorderSide(
                                  color: Colors.grey,
                                  width: 2.0,
                                  style: BorderStyle.solid),
                              value: todos[index]
                                  ["isCheck"], //  <-- leading Checkbox
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _dialogBuilder(
              context: context,
              todoController: todoController,
              action: () => addNewTodo());
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
    action}) async {
  String task;

  final test;

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
                    Text("Add new todos"),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: customTextField(
                          placeholder: 'todos',
                          inputType: TextInputType.text,
                          inputController: todoController),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        child: Text("Add"),
                        onPressed: () async {
                          await action();
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      });
}
