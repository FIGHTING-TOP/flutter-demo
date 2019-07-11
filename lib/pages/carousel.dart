import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CarouselPage extends StatefulWidget {
  CarouselPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CarouselPageState createState() => new _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              child: Container(
                child: Image.network("http://via.placeholder.com/350x150",
                    fit: BoxFit.fill),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/perspective');
              },
            );
        },
        itemCount: 3,
        pagination: new SwiperPagination(),
        control: new SwiperControl(),
      ),
    );
  }
}