import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task/network_utils/Auth.dart';
import 'package:task/providers/TodoProviders.dart';
import './screen/Home.dart';
import './screen/Login.dart';
import './screen/Register.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

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
  late Future? isLoggedIn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // isLoggedIn = getToken();
    // print(isLoggedIn);
  }

  Future? getToken() {
    return Auth().getLocalItem('_token').then((token) {
      return token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: isLoggedIn != null ? Home() : Login(),
      home: FutureBuilder(
          future: getToken(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print('main: ${snapshot.data}');
            if (snapshot.hasData) {
              return Home();
            } else {
              return Login();
            }
          }),

      //? this is the routes
      routes: {
        '/home': (context) => Home(),
        '/login': (context) => Login(),
        '/register': (context) => Register()
      },
    );
  }
}
