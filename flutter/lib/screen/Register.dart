import 'package:flutter/material.dart';
import 'package:task/widgets/custom_passwordField.dart';
import 'package:task/widgets/custom_textField.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sign up',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Create an account, It's free",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              SizedBox(
                height: 30,
              ),
              customTextField(
                placeholder: 'Email',
                inputType: TextInputType.emailAddress,
                inputController: emailController,
              ),
              SizedBox(
                height: 20,
              ),
              passwordTextField(
                placeholder: 'Password',
                inputController: passwordController,
              ),
              SizedBox(
                height: 20,
              ),
              passwordTextField(
                placeholder: 'Confirm password',
                inputController: confPasswordController,
              ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Sign up',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      padding: EdgeInsets.all(12)),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Wrap(
                children: [
                  Text('Already have an account?'),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/login'),
                    child: Text(
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
    );
  }
}
