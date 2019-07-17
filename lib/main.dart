import 'package:flutter/material.dart';
import 'package:flutterdemo/pages/home.dart';
import 'package:flutterdemo/pages/carousel.dart';
import 'package:flutterdemo/pages/rotate.dart';
import 'package:flutterdemo/pages/animation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
//      home: MyHomePage(),
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) =>
            MyHomePage(title: 'Flutter Demo Home Page'),
        '/carousel': (BuildContext context) => CarouselPage(title: 'carousel'),
        '/perspective': (BuildContext context) => PerspectivePage(),
        '/animation': (BuildContext context) => CardAnimated(),
      },
    );
  }
}
