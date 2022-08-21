// ignore_for_file: prefer_final_locals

import 'dart:convert';

import 'package:convert/convert.dart';

class Encrypt {
  static String passwordToEncryptKey(String password) {
    String passHex = hex.encode(utf8.encode(password));
    if (passHex.length > 32) {
      return passHex.substring(0, 32);
    }
    return passHex.padRight(32, '0');
  }
}
