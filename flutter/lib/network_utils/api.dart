import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:task/Models/User.dart';
import 'package:task/providers/TodoProviders.dart';

import '../Models/Todo.dart';

class Network {
  final String _url = 'http://192.168.0.107:8000/api';
  final storage = new FlutterSecureStorage();

  _storeValue(key, value) async {
    await storage.write(key: key, value: value);
  }

  Future<dynamic?> getUserName(String key) async {
    String? value = await storage.read(key: key);
    print('value: $value');
    return value;
  }

  Future requestLogin(data) async {
    final response =
        await http.post(Uri.parse('$_url/requestToken'), body: data);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      //? store token value
      await _storeValue('_token', data["Access-Token"]);
      await _storeValue('_user', json.encode(data["User"]));

      return data;
    } else {
      throw Exception('Something went wrong 🤔');
    }
  }

  Future requestTodo(id) async {
    final response = await http.get(Uri.parse('$_url/todo/$id'),
        headers: await _setHeaders());

    print(response.statusCode);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return data["todos"];
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future createTodo(newData) async {
    final response = await http.post(Uri.parse('$_url/createTodo'),
        headers: await _setHeaders(), body: jsonEncode(newData));

    if (response.statusCode == 200) {
      return response;
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

  Future register(data) async {
    final response = await http.post(Uri.parse('$_url/register'),
        headers: await _setHeaders(), body: jsonEncode(data));

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Something went wrong');
    }
  }
}
