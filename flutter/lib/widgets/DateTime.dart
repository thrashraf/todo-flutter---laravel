import 'package:flutter/material.dart';

Future<DateTime?> pickDate(context) => showDatePicker(
    context: context,
    initialDate:
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
    firstDate: DateTime(1900),
    lastDate: DateTime(2100));

Future<TimeOfDay?> pickTime(context) => showTimePicker(
    context: context,
    initialTime:
        TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute));
