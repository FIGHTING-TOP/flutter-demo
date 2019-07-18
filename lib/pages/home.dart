import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutterdemo/constant/color.dart';
import 'package:flutter/animation.dart';
import 'dart:math' as math;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Offset _offset = Offset.zero;
  Animation<double> animation;
  AnimationController animationController;
  double offsetStartX = 1;
  double cardWidth = 200;
  double cardHeight = 143;
  int delta = 26;
  bool rotateSign = true;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
//    animation = new CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn);
    animation = new Tween(begin: 0.0, end: 300.0).animate(animationController)
      ..addListener(() {
        print('1变');
        if (rotateSign) {
          offsetStartX += delta;
          setState(() {
            _offset = Offset(offsetStartX, 0);
          });
          if (offsetStartX >= 313) {
            setState(() {
              _offset = Offset(313, 0);
              rotateSign = false;
            });
            print('stop');
            animationController.stop();
          }
        } else {
          offsetStartX -= delta;
          setState(() {
            _offset = Offset(offsetStartX, 0);
          });
          if (offsetStartX <= 0) {
            print('stop');
            setState(() {
              _offset = Offset(0, 0);
              rotateSign = true;
            });
            animationController.stop();
          }
        }
      });
//      ..addStatusListener((status) {
//        if (status == AnimationStatus.completed) {
////          animationController.reverse();
//          print('2变');
//        } else if (status == AnimationStatus.dismissed) {
////          animationController.forward();
//          print('3变');
//        }
//      });
//    animationController.forward();
//    animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> swiperColumn = List();
    List<Widget> rowsList = List();
    for (int i = 1; i <= 9; i++) {
      if (i % 3 == 0) {
        rowsList.add(rowItemMaker(3, (i / 3).floor()));
        swiperColumn.add(Row(children: rowsList));
        rowsList = List();
      } else {
        rowsList.add(rowItemMaker(i % 3, (i / 3).floor() + 1));
      }
    }
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 10,
                  child: Container(
                    margin: EdgeInsets.only(left:16,top:20,bottom:10,right:5),
                    child: Image.asset('assets/img/glassesSmileHead.png'),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(bottom:10,top:20),
                    child: Image.asset('assets/img/pinkArrow.png'),
                  ),
                ),
                Expanded(
                  flex: 40,
                  child: Container(
                    margin: EdgeInsets.only(right:16,bottom:10,top:20),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      color: warnPink,
                    ),
                    height: 68,
                    child: Text('化工行业.'),
                  ),
                )
              ],
            ),
            Container(
//              color: Colors.red,
              height: 485,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: swiperColumn,
                  );
                },
                loop: false,
                itemCount: 3,
                pagination: new SwiperPagination(),
//            control: new SwiperControl(),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 18,
                  child: FlatButton(
                    color: myBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(300.0)),
                    ),
                    onPressed: () => animationController.repeat(),
                    child: Text(
                      '下一步',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
              ],
            ),
          ],
        )
    );
  }

  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget rowItemMaker(x,y) {
    return Expanded(
        flex: 1,
        child: Container(
          color: white,
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
//                onDoubleTap: () => setState(() => _offset = Offset.zero),
                onDoubleTap: () => Navigator.pushNamed(context, '/animation'),
                onTap: () => animationController.repeat(),
                child: Stack(
//                  alignment: const Alignment(0, -0.8),
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 8, top: 8, left: x == 1 ? 8 : 0),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: myBlueLighter,
                      ),
                      width: cardWidth,
                      height: cardHeight,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: myBlueLight, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Image.asset('assets/img/cardElement.png'),
                            ),
                            Expanded(
                              flex: 10,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '体型偏胖',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: mainText
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Transform.rotate(
                                angle: math.pi,
                                child: Image.asset('assets/img/cardElement.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Transform(
                        transform: Matrix4.identity() //生成一个单位矩阵
//                          ..setEntry(3, 2, 0.001) // 透视
                          ..rotateY(-math.pi), // changed
                        alignment: FractionalOffset.center,
                        child: Text('这个是背面'),
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }
}
