import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:task/Models/User.dart';

class Network {
  final String _url = 'http://192.168.0.107:8000/api/';
  final storage = new FlutterSecureStorage();

  _storeValue(key, value) async {
    await storage.write(key: key, value: value);
  }

  Future<dynamic?> getUserName(String key) async {
    String? value = await storage.read(key: key);
    print('value: $value');
    return value;
  }

  authData(data, endpoint) async {
    dynamic fullUrl = _url + endpoint;
    var response = await http.post(Uri.parse(fullUrl), body: data);

    var respondedData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      String token = respondedData["Access-Token"];

      await _storeValue('_token', token);
      await _storeValue('_user', json.encode(respondedData["User"]));

      token = getUserName('_token').toString();

      return respondedData;
    }
  }

  getData(apiUrl) async {
    dynamic fullUrl = _url + apiUrl;

    try {
      var respond =
          await http.get(Uri.parse(fullUrl), headers: await _setHeaders());

      var data = jsonDecode(respond.body);
      print(respond.statusCode);
      if (respond.statusCode != 200) {
        return Future.error('Something went wrong');
      }

      return data;
    } catch (e) {
      print(e);
    }
  }

  createTodo(apiUrl, newData) async {
    dynamic fullUrl = _url + apiUrl;
    try {
      var respond = await http.post(Uri.parse(fullUrl),
          headers: await _setHeaders(), body: jsonEncode(newData));
      print(fullUrl);
      var data = jsonDecode(respond.body);

      return data;
    } catch (e) {
      return Future.error('Something went wrong');
    }
  }

  updateTodo(apiUrl, newData) async {
    dynamic fullUrl = _url + apiUrl;
    try {
      var respond = await http.put(Uri.parse(fullUrl),
          headers: await _setHeaders(), body: jsonEncode(newData));
      var data = jsonDecode(respond.body);

      return data;
    } catch (e) {
      return Future.error('Something went wrong');
    }
  }

  delete(apiUrl) async {
    dynamic fullUrl = _url + apiUrl;
    try {
      var respond =
          await http.delete(Uri.parse(fullUrl), headers: await _setHeaders());
      var data = jsonDecode(respond.body);

      return data;
    } catch (e) {
      return Future.error('Something went wrong');
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

  logout(apiUrl) async {
    dynamic fullUrl = _url + apiUrl;
    try {
      var respond =
          await http.delete(Uri.parse(fullUrl), headers: await _setHeaders());
      var data = jsonDecode(respond.body);

      await storage.deleteAll();

      return data;
    } catch (e) {
      return Future.error('Something went wrong');
    }
  }

  register(apiUrl, newData) async {
    dynamic fullUrl = _url + apiUrl;
    print(fullUrl);
    try {
      var respond = await http.post(Uri.parse(fullUrl), body: newData);

      print(respond.statusCode);
      var data = jsonDecode(respond.body);

      await storage.deleteAll();

      return respond;
    } catch (e) {
      return Future.error(e);
    }
  }
}
