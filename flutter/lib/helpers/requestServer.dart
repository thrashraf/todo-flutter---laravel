import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';

Future requestServer(request) async {
  try {
    final response = await request();
    return response;

    // return await computation();
  } on SocketException {
    Fluttertoast.showToast(
        msg: "No internet connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red[200],
        textColor: Colors.white,
        fontSize: 16.0);
  } on HttpException catch (e) {
    Fluttertoast.showToast(
        msg: "${e.message}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red[200],
        textColor: Colors.white,
        fontSize: 16.0);
  } on FormatException {
    Fluttertoast.showToast(
        msg: "Bad response",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red[200],
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
