import 'package:flutter/material.dart';

class customTextField extends StatefulWidget {
  String placeholder;
  dynamic inputType;
  dynamic inputController;

  customTextField(
      {required this.placeholder,
      required this.inputType,
      required this.inputController});
  @override
  State<customTextField> createState() => _customTextFieldState();
}

class _customTextFieldState extends State<customTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: widget.inputController,
        keyboardType: widget.inputType,
        decoration: InputDecoration(
          labelText: widget.placeholder,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(20),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Colors.transparent, width: 0.0),
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
