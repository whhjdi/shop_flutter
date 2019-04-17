import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
            title: Text('首页'),
          ),
          body: FutureBuilder(
            future: getHomePage(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = json.decode(snapshot.data.toString());
                List<Map> swiper = (data['data']['slides'] as List).cast();
                return Column(
                  children: <Widget>[MySwiper(swiperList: swiper)],
                );
              } else {}
            },
          )),
    );
  }
}

class MySwiper extends StatelessWidget {
  final List swiperList;
  MySwiper({Key key, this.swiperList}) : super();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Container(
      height: ScreenUtil.getInstance().setHeight(333),
      width: ScreenUtil.getInstance().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return new Image.network(
            "${swiperList[index]['image']}",
            fit: BoxFit.fill,
          );
        },
        itemCount: swiperList.length,
        pagination: SwiperPagination(),
        control: SwiperControl(),
        autoplay: true,
      ),
    );
  }
}
