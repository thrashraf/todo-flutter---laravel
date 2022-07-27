import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:task/widgets/custom_passwordField.dart';
import 'package:task/widgets/custom_textField.dart';

import '../helpers/requestServer.dart';
import '../network_utils/api.dart';
import '../widgets/CustomFormField.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool successRegister = false;

  void _register() async {
    var data = {
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'c_password': confPasswordController.text
    };

    var response = await requestServer((() => Network().register(data)));

    if (response != null) {
      Fluttertoast.showToast(
          msg: "Successful register! 🎉",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green[200],
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.popAndPushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sign up',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Create an account, It's free",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomForm(
                          label: 'Name',
                          validation: (name) {
                            if (name == null || name.isEmpty) {
                              return 'please insert Name';
                            }
                            return null;
                          },
                          isPassword: false,
                          textController: nameController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomForm(
                          label: 'Email',
                          validation: (email) => EmailValidator.validate(email)
                              ? null
                              : "Invalid email address",
                          isPassword: false,
                          textController: emailController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomForm(
                          label: 'Password',
                          validation: (password) {
                            final RegExp regex = RegExp(
                                r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$');
                            if (!regex.hasMatch(password)) {
                              return 'Password must contain upper case and lower case 8 character minimum';
                            } else {
                              return null;
                            }
                          },
                          isPassword: true,
                          textController: passwordController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomForm(
                          label: 'Confirm password',
                          validation: (confirmPassword) {
                            if (confirmPassword.isEmpty ||
                                confirmPassword != passwordController.text) {
                              return 'Password not match';
                            }
                            return null;
                          },
                          isPassword: true,
                          textController: confPasswordController,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _register();
                              }
                            },
                            style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                padding: const EdgeInsets.all(12)),
                            child: const Text(
                              'Sign up',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 50,
                ),
                Wrap(
                  children: [
                    const Text('Already have an account?'),
                    GestureDetector(
                      onTap: () => Navigator.popAndPushNamed(context, '/login'),
                      child: const Text(
                        ' Log In',
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}

Future toast() {
  return Fluttertoast.showToast(
      msg: "This is Center Short Toast",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
