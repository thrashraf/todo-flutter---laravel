import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import './screen/Home.dart';
import './screen/Login.dart';
import './screen/Register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = new FlutterSecureStorage();
  dynamic isLoggedIn = await storage.read(key: '_token');
  print(isLoggedIn);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: isLoggedIn != null ? Home() : Login(),

    //? this is the routes
    routes: {
      '/home': (context) => Home(),
      '/login': (context) => Login(),
      '/register': (context) => Register()
    },
  ));
}
