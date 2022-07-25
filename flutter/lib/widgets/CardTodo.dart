import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:task/providers/TodoProviders.dart';
import 'package:task/widgets/Dialog.dart';

import '../Models/Todo.dart';

class CardTodo extends StatelessWidget {
  late Todo todo;
  late int index;
  late TextEditingController todoController;
  late Todo newTodo;

  CardTodo(
      {required this.todo,
      required this.index,
      required this.todoController,
      required this.newTodo});

  @override
  Widget build(BuildContext context) {
    bool intToBool(int a) => a == 0 ? false : true;
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
              onPressed: (BuildContext context) => showDialog(
                  builder: (context) => DialogWidget(
                        mode: 'edit',
                        todo: todo,
                      ),
                  context: context),
            ),
            SlidableAction(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                label: 'Delete',
                onPressed: (BuildContext context) =>
                    Provider.of<TodoProviders>(context, listen: false)
                        .deleteTodo(todo)),
          ],
        ),
        child: CheckboxListTile(
            contentPadding: const EdgeInsets.all(7),
            title: Text(
              todo.task,
              style: TextStyle(
                  decoration:
                      todo.intToBool() ? TextDecoration.lineThrough : null,
                  fontSize: 20),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (bool? value) {
              Provider.of<TodoProviders>(context, listen: false)
                  .checkTodo(index);
            },
            activeColor: Colors.grey[400],
            checkboxShape: CircleBorder(),
            side: BorderSide(
                color: index.isEven
                    ? Color.fromRGBO(58, 180, 242, 1)
                    : Color.fromRGBO(246, 55, 236, 1),
                width: 2.0,
                style: BorderStyle.solid),
            value: todo.intToBool() //  <-- leading Checkbox
            ),
      ),
    );
  }
}
