import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutterdemo/constant/color.dart';
import 'package:flutter/animation.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  Offset _offset = Offset.zero;
  Animation<double> animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
//    animation = new CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn);
    animation = new Tween(begin: 0.0, end: 300.0).animate(animationController)
      ..addListener(() {
        print('1变');
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
          print('2变');
        } else if (status == AnimationStatus.dismissed) {
          animationController.forward();
          print('3变');
        }
      });
    animationController.forward();
//    animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(
        color: black,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                rowMaker(),
              ],
            );
          },
          itemCount: 3,
          pagination: new SwiperPagination(),
          control: new SwiperControl(),
        ),
      )
    );
  }

  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  rowItemMaker(){
    return Expanded(
        flex: 1,
        child: Container(
          color: black,
          child: Transform(
            // Transform widget
              transform: Matrix4.identity() //生成一个单位矩阵
                ..setEntry(3, 2, 0.001) // 透视
                ..rotateX(0.01 * _offset.dy) // changed
                ..rotateY(-0.01 * _offset.dx), // changed
              alignment: FractionalOffset.center,
              child: GestureDetector(
//                onPanUpdate: (details) =>
//                    setState(() => _offset += details.delta), //与屏幕接触并移动的指针再次移动
                onDoubleTap: () => setState(() => _offset = Offset.zero),
//                onDoubleTap: () => Navigator.pushNamed(context, '/animation'),
                onTap: () => setState(() => _offset = Offset(300.0,0.0)),
                child: Image.network("http://via.placeholder.com/350x150",
                    fit: BoxFit.fill),
              )
          ),
        )
    );
  }

  rowMaker(){
    List<Widget> rowsList = List();
    for(int i = 0;i < 3;i++){
      rowsList.add(rowItemMaker());
    }
    return Row(
      children: rowsList,
    );
  }
}