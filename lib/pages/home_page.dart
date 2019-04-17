import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

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
                List recommendList = (newData['recommend'] as List).cast();
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      MySwiper(swiperList: swiper),
                      TopNav(navList: navList),
                      AdBanner(adPic: adPic),
                      Recommend(
                        recommendList: recommendList,
                      ),
                    ],
                  ),
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

class Recommend extends StatelessWidget {
  final List recommendList;
  Recommend({Key key, this.recommendList}) : super(key: key);

  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 2.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.black12),
        ),
      ),
      child: Text('商品推荐',
          style: TextStyle(
            color: Colors.red,
          )),
    );
  }

  Widget _recommendList() {
    return Container(
      height: ScreenUtil.getInstance().setHeight(280.0),
      margin: EdgeInsets.only(top: 5.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context, index) {
          return _item(index);
        },
      ),
    );
  }

  Widget _item(index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil.getInstance().setHeight(280.0),
        width: ScreenUtil.getInstance().setWidth(250.0),
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: Colors.white24,
            border: Border(
              left: BorderSide(width: 0.5, color: Colors.black12),
            )),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.getInstance().setHeight(350),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList(),
        ],
      ),
    );
  }
}
