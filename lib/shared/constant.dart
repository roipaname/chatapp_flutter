import 'package:flutter/material.dart';

class Constants {
  static String appId = "1:19660779007:web:fc6ea7e11721b5dee00bca";
  static String apiKey = "AIzaSyDJW4OZNJKjWx1sRcByl0_szmHOFaDYxZc";
  static String messagingSenderId = "19660779007";
  static String projectId = "chatappflutter-1a83a";
  static Color primaryColor = const Color(0xFFee7b64);
}

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}
