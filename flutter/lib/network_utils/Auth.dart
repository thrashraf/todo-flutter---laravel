import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:task/providers/TodoProviders.dart';
import '../Models/Todo.dart';

//firebase package
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

//device info package
import 'package:device_info_plus/device_info_plus.dart';

class Auth {
  final String _url = 'http://192.168.0.107:8000/api';
  final storage = new FlutterSecureStorage();

  _storeValue(key, value) async {
    await storage.write(key: key, value: value);
  }

  Future<dynamic?> getLocalItem(String key) async {
    String? value = await storage.read(key: key);
    return value;
  }

  Future requestLogin(data) async {
    final response =
        await http.post(Uri.parse('$_url/requestToken'), body: data);

    if (response.statusCode != 200) {
      throw const HttpException('Invalid credentials');
    }

    var res = jsonDecode(response.body);

    //? store token value
    await _storeValue('_token', res["Access-Token"]);
    await _storeValue('_user', json.encode(res["User"]));

    return response;
  }

  _setHeaders() async {
    String? token = await storage.read(key: '_token');
    print('token: $token');

    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }

  Future logout() async {
    final response = await http.delete(Uri.parse('$_url/logout'),
        headers: await _setHeaders());
    if (response.statusCode == 200) {
      await storage.deleteAll();
      return response;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future register(data) async {
    final response = await http.post(Uri.parse('$_url/register'),
        headers: await _setHeaders(), body: jsonEncode(data));

    var res = jsonDecode(response.body);
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw HttpException('email already exist');
    }

    return response;
  }

  Future<bool> loginWithGoogle() async {
    var _user;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    var authResult = await _auth.signInWithCredential(credential);
    _user = authResult.user;
    var currentUser = await _auth.currentUser!;

    // getting device name
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    // building request body
    dynamic body = {
      'token': googleSignInAuthentication.accessToken,
      'device_name': androidInfo.id,
    };

    final response = await http.post(
        Uri.parse('http://192.168.0.107:8000/api/google'),
        body: body,
        headers: {'Accept': 'application/json'});

    // // make request and await response
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);

      //? store token value
      await _storeValue('_token', res["Access-Token"]);
      await _storeValue('_user', json.encode(res["User"]));

      return true;
    } else {
      return false;
    }
  }
}
