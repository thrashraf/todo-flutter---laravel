import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task/network_utils/api.dart';
import 'package:task/widgets/Navbar.dart';
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     IconButton(
                  //       icon: Icon(
                  //         Icons.menu,
                  //         color: Colors.grey[500],
                  //       ),
                  //       onPressed: () {
                  //         () => Scaffold.of(context).openDrawer();
                  //       },
                  //     ),
                  //     Row(
                  //       children: [
                  //         Icon(
                  //           Icons.search_outlined,
                  //           color: Colors.grey[500],
                  //         ),
                  //         SizedBox(width: 30),
                  //         Icon(
                  //           Icons.notifications_outlined,
                  //           color: Colors.grey[500],
                  //         ),
                  //       ],
                  //     )
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 50,
                  // ),
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
                    height: 20,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Slidable(
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
                                        action: () => editTodo(index),
                                        mode: 'edit');
                                  },
                                ),
                                SlidableAction(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  label: 'Delete',
                                  onPressed: (BuildContext context) {
                                    setState(() {
                                      todos.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                            child: CheckboxListTile(
                              contentPadding: const EdgeInsets.all(7),
                              title: Text(
                                todos[index]["title"],
                                style: TextStyle(
                                    decoration: todos[index]["isCheck"]
                                        ? TextDecoration.lineThrough
                                        : null,
                                    fontSize: 20),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (bool? value) {
                                setState(() {
                                  todos[index]["isCheck"] =
                                      !todos[index]["isCheck"];
                                });
                              },
                              activeColor: Colors.grey[400],
                              checkboxShape: CircleBorder(),
                              side: BorderSide(
                                  color: index.isEven
                                      ? Color.fromRGBO(58, 180, 242, 1)
                                      : Color.fromRGBO(246, 55, 236, 1),
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
