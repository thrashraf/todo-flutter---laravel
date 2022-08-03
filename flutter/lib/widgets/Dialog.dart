import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/providers/TodoProviders.dart';
import 'package:task/widgets/CustomFormField.dart';
import 'package:task/widgets/DateTime.dart';
import '../Models/Todo.dart';

import 'package:task/network_utils/Notification.dart';

class DialogWidget extends StatefulWidget {
  String mode;
  Todo todo;
  DialogWidget({Key? key, required this.mode, required this.todo})
      : super(key: key);

  @override
  State<DialogWidget> createState() => _DialogState();
}

class _DialogState extends State<DialogWidget> {
  late DateTime? dateTime = null;

  late final Notifications service;

  @override
  void initState() {
    // TODO: implement initState

    service = Notifications();
    service.initialize();
  }

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
          form(
            mode: widget.mode,
            editTodo: widget.todo,
          )
        ],
      ),
    );
  }
}

class form extends StatelessWidget {
  final editTodo;
  final mode;

  const form({
    Key? key,
    required this.mode,
    required this.editTodo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = TextEditingController();
    final provider = Provider.of<TodoProviders>(context, listen: false);
    late Todo newTodo = Todo(id: editTodo.id, task: title.text, isCheck: 0);

    DateTime? dateTime;
    final _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(8.0),
              child: CustomForm(
                  label: 'todos',
                  validation: (text) {
                    if (text == null || text.isEmpty) {
                      return 'please insert text';
                    }
                    return null;
                  },
                  isPassword: false,
                  textController: title)),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ElevatedButton.icon(
                  onPressed: () async {
                    final date = await pickDate(context);

                    if (date == null) return;
                    final time = await pickTime(context);

                    if (time == null) return;
                    dateTime = DateTime(date.year, date.month, date.day,
                        time.hour, time.minute);
                  },
                  icon: Icon(Icons.alarm),
                  label: const Text('Add Reminder')),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (mode != 'add') {
                    provider.editTodo(editTodo, newTodo);
                  } else {
                    provider.addNewTodo(newTodo, dateTime);
                  }
                }

                Navigator.pop(context);
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
      ),
    );
  }
}
