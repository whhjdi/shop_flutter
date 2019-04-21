import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluro/fluro.dart';
import '../router/application.dart';
import './home_page/my_swiper.dart';
import './home_page/floor.dart';
import './home_page/recommend.dart';
import './home_page/top_nav.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  int page = 1;
  List<Map> hotGoodsList = [];

  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
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
              String floorPic1 = newData['floor1Pic']['PICTURE_ADDRESS'];
              List<Map> floorList1 = (newData['floor1'] as List).cast();
              String floorPic2 = newData['floor2Pic']['PICTURE_ADDRESS'];
              List<Map> floorList2 = (newData['floor2'] as List).cast();
              String floorPic3 = newData['floor3Pic']['PICTURE_ADDRESS'];
              List<Map> floorList3 = (newData['floor3'] as List).cast();

              return EasyRefresh(
                refreshHeader: ClassicsHeader(
                  key: _headerKey,
                  bgColor: Colors.white,
                  textColor: Colors.red,
                  moreInfoColor: Colors.red,
                  isFloat: true,
                  showMore: true,
                  refreshText: '下拉刷新',
                  refreshReadyText: '松开刷新',
                  refreshedText: '刷新完成',
                  refreshingText: '正在刷新',
                ),
                refreshFooter: ClassicsFooter(
                  key: _footerKey,
                  bgColor: Colors.white,
                  textColor: Colors.red,
                  moreInfo: '正在加载',
                  moreInfoColor: Colors.red,
                  noMoreText: '刷新完成',
                  loadReadyText: '松开刷新',
                ),
                key: _easyRefreshKey,
                child: ListView(
                  children: <Widget>[
                    MySwiper(swiperList: swiper),
                    TopNav(navList: navList),
                    _adBanner(adPic),
                    Recommend(
                      recommendList: recommendList,
                    ),
                    FloorTitle(pic: floorPic1),
                    FloorProduct(productList: floorList1),
                    FloorTitle(pic: floorPic2),
                    FloorProduct(productList: floorList2),
                    FloorTitle(pic: floorPic3),
                    FloorProduct(productList: floorList3),
                    _hotGoods(),
                  ],
                ),
                onRefresh: () async {
                  getHomePage();
                },
                loadMore: () async {
                  _getHotGoods();
                },
              );
            } else {
              return Center(
                child: Text('加载中'),
              );
            }
          },
        ),
      ),
    );
  }

  void _getHotGoods() {
    var formData = {'page': page};
    getHomePageHot(formData).then((res) {
      List<Map> newGoodsList =
          (json.decode(res.toString())['data'] as List).cast();
      setState(() {
        hotGoodsList.addAll(newGoodsList);
        page++;
      });
    });
  }

  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),
    padding: EdgeInsets.only(bottom: 10.0),
    alignment: Alignment.center,
    child: Text('火爆专区'),
  );

  Widget _wrapList() {
    if (hotGoodsList.length != 0) {
      List<Widget> listWidget = hotGoodsList.map((hotGood) {
        return InkWell(
          onTap: () {
            Application.router.navigateTo(
                context, "/detail?id=${hotGood['goodsId']}",
                transition: TransitionType.fadeIn);
          },
          child: Container(
            width: ScreenUtil.getInstance().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(
                  hotGood['image'],
                  width: ScreenUtil.getInstance().setWidth(370),
                ),
                Text(
                  hotGood['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: ScreenUtil.getInstance().setSp(26),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text('￥${hotGood['mallPrice']}'),
                    Text(
                      '￥${hotGood['price']}',
                      style: TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text('');
    }
  }

  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList(),
        ],
      ),
    );
  }
}

Widget _adBanner(adPic) {
  return Image.network(adPic);
}
