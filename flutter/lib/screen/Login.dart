import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task/network_utils/api.dart';
import 'package:task/screen/Home.dart';
import 'package:task/widgets/custom_passwordField.dart';
import '../Models/User.dart';
import '../providers/UserProviders.dart';
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

      try {
        var respond = await Network().authData(data, 'requestToken');
        print(respond['User']);
        User userData = User(
            id: respond["User"]["id"],
            name: respond["User"]["name"],
            email: respond["User"]["email"],
            token: respond["Access-Token"]);
        print(userData);
        Provider.of<UserProvider>(context, listen: false).addUser(userData);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Home()),
          (Route<dynamic> route) => false,
        );
      } catch (e) {
        print(e);
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
                customTextField(
                  placeholder: 'Email',
                  inputType: TextInputType.emailAddress,
                  inputController: emailController,
                ),
                SizedBox(
                  height: 15,
                ),
                passwordTextField(
                    placeholder: 'Password',
                    inputController: passwordController),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/register'),
                  child: Text(
                    'Forgot password?',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _login(),
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        padding: EdgeInsets.all(12)),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
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
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: double.infinity,
                    child: InkWell(
                      onTap: () {},
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
                              SizedBox(width: 12),
                              Text(
                                'Sign in with Google',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                SizedBox(
                  height: 40,
                ),
                Wrap(
                  children: [
                    Text('Not a member?'),
                    GestureDetector(
                      onTap: () =>
                          Navigator.popAndPushNamed(context, '/register'),
                      child: Text(
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
}
