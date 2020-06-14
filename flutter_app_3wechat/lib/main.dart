import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp3wechat/root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Wechat',
      theme: ThemeData(
        highlightColor: Color.fromRGBO(1, 0, 0, 0.0),//解决bottomitem点击时的点击效果
        splashColor: Color.fromRGBO(1, 0, 0, 0.0),//解决bottomitem点击时的点击效果
        primarySwatch: Colors.blue,
      ),
      home: RootPage(),
    );
  }
}

