import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task/network_utils/api.dart';
import 'package:task/providers/TodoProviders.dart';
import './screen/Home.dart';
import './screen/Login.dart';
import './screen/Register.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoProviders()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var isLoggedIn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Network().getUserName('_token').then((token) {
      setState(() {
        isLoggedIn = token;
        print('token: $isLoggedIn');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isLoggedIn != null ? Home() : Login(),
      //? this is the routes
      routes: {
        '/home': (context) => Home(),
        '/login': (context) => Login(),
        '/register': (context) => Register()
      },
    );
  }
}
