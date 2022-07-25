import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/providers/TodoProviders.dart';
import '../Models/Todo.dart';
import 'custom_textField.dart';

class DialogWidget extends StatefulWidget {
  String mode;
  Todo todo;
  DialogWidget({Key? key, required this.mode, required this.todo})
      : super(key: key);

  @override
  State<DialogWidget> createState() => _DialogState();
}

class _DialogState extends State<DialogWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            widget.mode == 'add' ? "Add new todo" : "Edit todo",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Form(mode: widget.mode, context: context, editTodo: widget.todo)
        ],
      ),
    );
  }
}

Widget Form({required mode, required context, required editTodo}) {
  final title = TextEditingController();
  final provider = Provider.of<TodoProviders>(context, listen: false);
  late Todo newTodo = Todo(task: title.text, isCheck: 0);
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.all(8.0),
        child: customTextField(
            placeholder: 'todos',
            inputType: TextInputType.text,
            inputController: title),
      ),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (mode != 'add') {
              provider.editTodo(editTodo, newTodo);
            } else {
              provider.addNewTodo(newTodo);
            }
          },
          style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              padding: EdgeInsets.all(12)),
          child: Text('Saved'),
        ),
      ),
    ],
  );
}
