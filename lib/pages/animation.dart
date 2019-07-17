import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutterdemo/constant/color.dart';
import 'package:flutter/animation.dart';
import 'dart:math' as math;

class CardAnimated extends StatefulWidget {
  @override
  _CardAnimatedState createState() => new _CardAnimatedState();
}

class _CardAnimatedState extends State<CardAnimated>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animationController;
  List rowItems1 = [
    {'x': 200, 'y': 300},
    {'x': 0, 'y': 300},
    {'x': -200, 'y': 300}
  ];
  List rowItems2 = [
    {'x': 200, 'y': 0},
    {'x': 0, 'y': 0},
    {'x': -200, 'y': 0}
  ];
  List rowItems3 = [
    {'x': 200, 'y': -300},
    {'x': 0, 'y': -300},
    {'x': -200, 'y': 300}
  ];
  double xn = 200;
  double yn = 220;
  bool cardPlaySign = true;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
//    animation = new CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn);
    animation = new Tween(begin: 0.0, end: 300.0).animate(animationController)
      ..addListener(() {
        print('1变');
        if (cardPlaySign) {
          if (xn > 0) {
            setState(() {
              xn -= 20;
            });
          } else {
            if (yn > 0) {
              setState(() {
                yn -= 22;
              });
            }
          }
        } else {
          if (xn < 200) {
            setState(() {
              xn += 20;
            });
          } else {
            if (yn < 220) {
              setState(() {
                yn += 22;
              });
            }
          }
        }
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            xn = 0;
            yn = 0;
            cardPlaySign = false;
          });
          print('forward done');
        } else if (status == AnimationStatus.dismissed) {
          setState(() {
            xn = 200;
            yn = 220;
            cardPlaySign = true;
          });
          print('reverse done');
        }
      });
    animationController.forward();
//    animationController.repeat();
//    animationController.reverse();
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
          title: new Text('症状选择'),
        ),
        body: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              height: 700,
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
                    onPressed: () => animationController.reverse(),
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
        ));
  }

  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget rowItemMaker(x, y) {
    // x代表一行的第几个，y代表第几行
    print(x);
    print(y);
    double rx;
    double ry;
    if (x == 1) {
      rx = xn;
    } else if (x == 2) {
      rx = 0;
    } else if (x == 3) {
      rx = -xn;
    }
    if (y == 1) {
      ry = yn;
    } else if (y == 2) {
      ry = 0;
    } else if (y == 3) {
      ry = -yn;
    }
    return Expanded(
        flex: 1,
        child: Container(
          color: white,
          child: Transform(
              transform: Matrix4.translationValues(rx, ry, 0),
              alignment: FractionalOffset.center,
              child: Container(
                margin: EdgeInsets.only(right: 8, top: 8, left: x == 1 ? 8 : 0),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  color: myBlueLighter,
                ),
                width: 200,
                height: 220,
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
                              fontSize: 24,
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
              )),
        ));
  }
}
