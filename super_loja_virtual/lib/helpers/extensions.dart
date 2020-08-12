import 'package:flutter/material.dart';

extension Extra on TimeOfDay {
  String formatted() {
    return '${hour}h${minute.toString().padLeft(2, '0')}';
  }

  int toMinutes()=> hour*60+minute;
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}