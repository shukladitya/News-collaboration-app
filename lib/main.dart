import 'package:flutter/material.dart';
import 'package:tod/Login.dart';
import 'package:tod/dashboard.dart';
import 'package:tod/signup.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tod/submitnews.dart';
import 'package:tod/tagcard.dart';
import 'package:tod/verifynews.dart';

import 'about.dart';

void main() {
  runApp(Tod());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.doubleBounce
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 5.0;
}

class Tod extends StatefulWidget {
  @override
  _TodState createState() => _TodState();
}

class _TodState extends State<Tod> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      routes: {
        'signup': (context) => Signup(),
        'dashboard': (context) => Dashboard(),
        'submitnews': (context) => Submitnews(),
        'verifynews': (context) => Verifynews(),
        'tagcard': (context) => Tagcard(),
        'about': (context) => About(),
      },
      builder: EasyLoading.init(),
    );
  }
}
