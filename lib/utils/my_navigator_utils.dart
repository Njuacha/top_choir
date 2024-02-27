import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyNavUtils {
  static navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}
