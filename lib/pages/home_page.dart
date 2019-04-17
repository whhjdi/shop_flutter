import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

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
                var newData = data['data'];
                List<Map> swiper = (newData['slides'] as List).cast();
                List<Map> navList = (newData['category'] as List).cast();
                String adPic = newData['advertesPicture']['PICTURE_ADDRESS'];
                String leaderImage = newData['shopInfo']['leaderImage'];
                String leaderPhone = newData['shopInfo']['leaderPhone'];

                return Column(
                  children: <Widget>[
                    MySwiper(swiperList: swiper),
                    TopNav(navList: navList),
                    AdBanner(adPic: adPic),
                    Contact(leaderImage: leaderImage, leaderPhone: leaderPhone)
                  ],
                );
              } else {
                return Center(
                  child: Text('加载中'),
                );
              }
            },
          )),
    );
  }
}

class MySwiper extends StatelessWidget {
  final List swiperList;
  MySwiper({Key key, this.swiperList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.getInstance().setHeight(250.0),
      width: ScreenUtil.getInstance().setWidth(750.0),
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

class TopNav extends StatelessWidget {
  final List<Map> navList;
  TopNav({Key key, this.navList}) : super(key: key);

  Widget _gridViewItem(BuildContext context, item) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: <Widget>[
          Image.network(
            item['image'],
            width: ScreenUtil.getInstance().setWidth(95.0),
          ),
          Text(item['mallCategoryName']),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.navList.length > 10) {
      this.navList.removeRange(10, this.navList.length);
    }

    return Container(
      height: ScreenUtil.getInstance().setHeight(250.0),
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navList.map((item) {
          return _gridViewItem(context, item);
        }).toList(),
      ),
    );
  }
}

class AdBanner extends StatelessWidget {
  final String adPic;
  AdBanner({Key key, this.adPic}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.network(adPic);
  }
}

class Contact extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;

  Contact({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launcherUrl,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launcherUrl() async {
    print(leaderPhone);
    String url = 'tel:' + leaderPhone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw '无效的url';
    }
  }
}
