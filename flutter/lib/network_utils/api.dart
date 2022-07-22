import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Network {
  final String _url = 'http://192.168.0.106:8000/api/';
  final storage = new FlutterSecureStorage();
  //if you are using android studio emulator, change localhost to 10.0.2.2
  late String token;

  _storeValue(key, value) async {
    await storage.write(key: key, value: value);
  }

  getValue(key) async {
    String? value = await storage.read(key: key);
    return value;
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
      storage.deleteAll();
      await _storeValue('_token', token);
      await _storeValue('_user', json.encode(respondedData["User"]));

      String? value = await storage.read(key: '_user');
      Map<String, String> allValues = await storage.readAll();
      print(value);
    }
    return respondedData;
  }

  // getData(apiUrl) async {
  //   dynamic fullUrl = _url + apiUrl;
  //   await _getToken();
  //   return await http.post(fullUrl, headers: _setHeaders());
  // }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };

  logout() async {
    await storage.deleteAll();
  }
}
