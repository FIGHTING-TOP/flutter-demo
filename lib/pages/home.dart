import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutterdemo/components/frontAndBackCard.dart';
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
  Animation<double> animation;
  AnimationController animationController;

  double cardWidth;
  double cardHeight;
  double xn;
  double yn;
  double cardMargin = 6;
  bool cardPlaySign = true;

  SwiperController swiperController;
  int swiperIndex = 0;
  int swiperCount = 1;
  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
//    animation = new CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn);
    animation = new Tween(begin: 0.0, end: 300.0).animate(animationController)
      ..addListener(animationHandler)
      ..addStatusListener(animationEndHandler);
  }

  @override
  Widget build(BuildContext context) {
    if (cardWidth == null) {
      final size = MediaQuery.of(context).size;
      cardWidth = size.width / 3;
      cardHeight = size.height / 4.5;
      xn = cardWidth - cardMargin;
      yn = cardHeight + cardMargin;
    }

    List<Widget> swiperContentList = List();
    List<Widget> rowsList = List();
    for (int i = 1; i <= 9; i++) {
      if (i % 3 == 0) {
        rowsList.add(cardItemMaker(i - 1, 3, (i / 3).floor()));
        swiperContentList.add(Row(children: rowsList));
        rowsList = List();
      } else {
        rowsList.add(cardItemMaker(i - 1, i % 3, (i / 3).ceil()));
      }
    }
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            topWidget(),
            Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: swiperContentList,
                      );
                    },
                    loop: false,
                    controller: swiperController,
                    index: swiperIndex,
                    onIndexChanged: (int index) {
                      setState(() {
                        swiperIndex = index;
                      });
                    },
                    itemCount: swiperCount,
                    pagination: new SwiperPagination(
                        margin: const EdgeInsets.only(top: 15.0),
                        builder: DotSwiperPaginationBuilder(
                            color: scaffoldBackgroundColor,
                            activeColor: myBlue)),
                  ),
                )),
            bottomWidget(),
          ],
        ));
  }

  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void animationHandler() {
    print('run animation');
    if (cardPlaySign) {
      if (xn > 0 && xn > (cardWidth + cardMargin) / 10) {
        setState(() {
          xn -= (cardWidth + cardMargin) / 10;
        });
      } else {
        if (yn > 0 && yn > (cardHeight + cardMargin) / 10) {
          setState(() {
            yn -= (cardHeight + cardMargin) / 10;
          });
        }
      }
    } else {
      if (xn < cardWidth - cardMargin) {
        setState(() {
          xn += (cardHeight - cardMargin) / 10;
        });
      } else {
        if (yn < cardHeight + cardMargin) {
          setState(() {
            yn += (cardHeight + cardMargin) / 10;
          });
        }
      }
    }
  }

  void animationEndHandler(status) {
    if (status == AnimationStatus.completed) {
      cardPlaySign = false;
      setState(() {
        xn = 0;
        yn = 0;
      });
      print('forward done');
    } else if (status == AnimationStatus.dismissed) {
      cardPlaySign = true;
      setState(() {
//        xn = cardWidth - cardMargin;
//        yn = cardHeight + cardMargin;
      });
      print('reverse done');
    }
  }

  //卡片3D 翻转
  Widget cardItemMaker(int index, int x, int y) {
    // x代表1，2，3行，也代表1，2，3列
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
    final frontComponent = Container(
        margin: EdgeInsets.only(
            right: x == 2 ? 0 : 6, top: y == 1 ? 0 : 6, left: x == 2 ? 0 : 6),
        padding: EdgeInsets.all(6),
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
                        color: mainText),
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
        ));
    final backComponent = Container(
      margin: EdgeInsets.only(
          right: x == 2 ? 0 : 6, top: y == 1 ? 0 : 6, left: x == 2 ? 0 : 6),
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: myBlue,
      ),
      width: cardWidth,
      height: cardHeight,
      child: Text('这个是背面'),
    );
    return Expanded(
        flex: 1,
        child: Transform(
            transform: Matrix4.translationValues(rx, ry, 0),
            alignment: FractionalOffset.center,
            child: Container(
              child: FlipCardComponent(
                frontComponent: frontComponent,
                backComponent: backComponent,
              ),
            )));
  }

  //顶部介绍
  Widget topWidget() {
    return Row(
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
            margin: EdgeInsets.only(right: 10, bottom: 10, top: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              color: warnPink,
            ),
            height: 55,
            child: Text('经舌象分析，您可能存在如下症状，请选择确认，获取精准指标和改善建议',
              style: TextStyle(
                  color: warnTextColor,
                  fontSize: 15
              ),),
            //经舌象分析，您可能存在如下症状，请选择确认，获取<span color="#66a0ee">精准指标和改善建议</span>
          ),
        )
      ],
    );
  }

  //页面底部 button ‘下一步’
  Widget bottomWidget() {
    return Row(
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
              borderRadius: BorderRadius.all(Radius.circular(100.0)),
            ),
            onPressed: () {
//              swiperController.next();
              animate();
            },
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
    );
  }

  void animate() {
//    animationController.stop();
//    animationController.value = 0;
    if (cardPlaySign) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }
}
