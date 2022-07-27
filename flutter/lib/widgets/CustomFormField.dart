import 'package:flutter/material.dart';

class CustomForm extends StatelessWidget {
  final String label;
  final validation;
  final bool isPassword;
  final TextEditingController textController;

  const CustomForm(
      {Key? key,
      required this.label,
      required this.validation,
      required this.isPassword,
      required this.textController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      validator: validation,
      controller: textController,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(20),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
