import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:task/network_utils/Notification.dart';
import 'package:task/providers/TodoProviders.dart';
import '../Models/Todo.dart';

//firebase package
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

//device info package
import 'package:device_info_plus/device_info_plus.dart';

class TodoApi {
  final String _url = 'http://192.168.0.107:8000/api';
  final storage = const FlutterSecureStorage();
  late final service = Notifications();

  Future requestTodo(id) async {
    final response = await http.get(Uri.parse('$_url/todo/$id'),
        headers: await _setHeaders());

    if (response.statusCode != 200) {
      throw HttpException('something went wrong');
    }
    var data = jsonDecode(response.body);
    return data["todos"];
  }

  Future createTodo(newData) async {
    final response = await http.post(Uri.parse('$_url/createTodo'),
        headers: await _setHeaders(), body: jsonEncode(newData));
    print(newData);
    var res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return res;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future updateTodo(id, newData) async {
    final response = await http.put(Uri.parse('$_url/updateTodo/$id'),
        headers: await _setHeaders(), body: jsonEncode(newData));
    print(response.body);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future delete(id) async {
    final response = await http.delete(Uri.parse('$_url/deleteTodo/$id'),
        headers: await _setHeaders());
    print(response.body);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Something went wrong');
    }
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
}
