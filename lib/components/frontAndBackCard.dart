import 'dart:math';
import 'package:flutter/material.dart';

// 3D效果借鉴一篇不错的文章 https://juejin.im/post/5b5534c951882562b9248294

class FlipCardComponent extends StatefulWidget {
  final Widget frontComponent;
  final Widget backComponent;
  const FlipCardComponent({Key key, this.frontComponent, this.backComponent})
      : super(key: key);

  @override
  _FlipCardComponentState createState() => _FlipCardComponentState();
}

class _FlipCardComponentState extends State<FlipCardComponent>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> frontAnimation;
  Animation<double> backAnimation;

  bool isFront = true;
  bool hasHalf = false;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 500));
    animationController.addListener(() {
      if (animationController.value > 0.5) {
        if (hasHalf == false) {
          isFront = !isFront;
        }
        hasHalf = true;
      }
      setState(() {});
    });
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        hasHalf = false;
      }
    });
    frontAnimation = Tween(begin: 0.0, end: 0.5).animate(CurvedAnimation(
        parent: animationController,
        curve: new Interval(0.0, 0.5, curve: Curves.easeIn)));
    backAnimation = Tween(begin: 1.5, end: 2.0).animate(CurvedAnimation(
        parent: animationController,
        curve: new Interval(0.5, 1.0, curve: Curves.easeOut)));
  }

  void animate() {
    animationController.stop();
    animationController.value = 0;
    animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double value = 0;
    if (animationController.status == AnimationStatus.forward) {
      if (hasHalf == true) {
        value = backAnimation.value;
      } else {
        value = frontAnimation.value;
      }
    }
    return GestureDetector(
      onTap: () {
        animate();
      },
      child: Container(
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002)
            ..rotateY(pi * value),
          alignment: Alignment.center,
          child: IndexedStack(
            index: isFront ? 0 : 1,
            children: <Widget>[widget.frontComponent, widget.backComponent],
          ),
        ),
      ),
    );
  }
}