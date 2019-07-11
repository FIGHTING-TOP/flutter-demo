import 'package:flutter/material.dart';
import 'package:flutterdemo/constant/color.dart';

class PerspectivePage extends StatefulWidget {
  PerspectivePage({Key key}) : super(key: key); // changed

  @override
  _PerspectivePageState createState() => _PerspectivePageState();
}

class _PerspectivePageState extends State<PerspectivePage> {
  Offset _offset = Offset.zero;

  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('perspective'),
        ),
        body: Container(
          color: black,
          child: Transform(
            // Transform widget
              transform: Matrix4.identity() //生成一个单位矩阵
                ..setEntry(3, 2, 0.001) // 透视
                ..rotateX(0.01 * _offset.dy) // changed
                ..rotateY(-0.01 * _offset.dx), // changed
              alignment: FractionalOffset.center,
              child: GestureDetector(
                // new
                onPanUpdate: (details) =>
                    setState(() => _offset += details.delta), //与屏幕接触并移动的指针再次移动
                onDoubleTap: () => setState(() => _offset = Offset.zero),
                child: _defaultApp(context),
              )
          ),
        )
    );
  }

  _defaultApp(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '3D效果',
            ),
          ],
        ),
      ),
    );
  }
}