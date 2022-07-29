import 'dart:convert';

import 'package:email_validator/email_validator.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:task/network_utils/Auth.dart';
import 'package:task/screen/Home.dart';
import 'package:task/widgets/CustomFormField.dart';
import 'package:task/widgets/custom_passwordField.dart';
import '../helpers/requestServer.dart';
import '../widgets/custom_textField.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:device_info_plus/device_info_plus.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void _login() async {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      var data = {
        'email': emailController.text,
        'password': passwordController.text,
        'device_name': androidInfo.model
      };

      var response = await requestServer((() => Auth().requestLogin(data)));

      if (response != null) {
        Fluttertoast.showToast(
            msg: "Successful login! 🎉",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green[200],
            textColor: Colors.white,
            fontSize: 16.0);

        Navigator.popAndPushNamed(context, '/home');
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                header(),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomForm(
                        label: 'Email',
                        validation: (email) => EmailValidator.validate(email)
                            ? null
                            : "Invalid email address",
                        isPassword: false,
                        textController: emailController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomForm(
                        label: 'Password',
                        validation: (password) {
                          if (password == null || password.isEmpty) {
                            return 'please insert Name';
                          }
                          return null;
                        },
                        isPassword: true,
                        textController: passwordController,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/register'),
                        child: const Text(
                          'Forgot password?',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _login();
                            }
                          },
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                              padding: EdgeInsets.all(12)),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: const [
                    Expanded(
                        child: Divider(
                      thickness: 1,
                    )),
                    SizedBox(
                      width: 20,
                    ),
                    Text('Or continue with'),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 1,
                    )),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: double.infinity,
                    child: InkWell(
                      onTap: () async {
                        bool req = await Auth().loginWithGoogle();

                        if (req) {
                          Navigator.popAndPushNamed(context, '/home');
                        }
                      },
                      child: Ink(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Image.asset(
                                'assets/googleIcon.webp',
                                fit: BoxFit.cover,
                                width: 20,
                                height: 40,
                              ), // <-- Use 'Image.asset(...)' here
                              const SizedBox(width: 12),
                              const Text(
                                'Sign in with Google',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 40,
                ),
                Wrap(
                  children: [
                    const Text('Not a member?'),
                    GestureDetector(
                      onTap: () =>
                          Navigator.popAndPushNamed(context, '/register'),
                      child: const Text(
                        ' Register now',
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }

  //? Login header
  Column header() {
    return Column(
      children: const [
        Text(
          'Hello Again!',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 20,
        ),
        Text("Welcome back you've ", style: TextStyle(fontSize: 20)),
        SizedBox(
          height: 5,
        ),
        Text("been missed!", style: TextStyle(fontSize: 20)),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
