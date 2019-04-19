import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluro/fluro.dart';
import '../router/application.dart';

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
                    AdBanner(adPic: adPic),
                    Recommend(
                      recommendList: recommendList,
                    ),
                    FloorTitle(pic: floorPic1),
                    FloorProduct(productList: floorList1),
                    // FloorTitle(pic: floorPic2),
                    // FloorProduct(productList: floorList2),
                    // FloorTitle(pic: floorPic3),
                    // FloorProduct(productList: floorList3),
                    _hotGoods(),
                  ],
                ),
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
      height: ScreenUtil.getInstance().setHeight(300.0),
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
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
      height: ScreenUtil.getInstance().setHeight(350.0),
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
        height: ScreenUtil.getInstance().setHeight(350.0),
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
      height: ScreenUtil.getInstance().setHeight(440),
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

class FloorTitle extends StatelessWidget {
  final String pic;
  FloorTitle({Key key, this.pic}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Image.network(pic),
    );
  }
}

class FloorProduct extends StatelessWidget {
  final productList;
  FloorProduct({Key key, this.productList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(),
          secondRow(),
        ],
      ),
    );
  }

  Widget _productItem(Map product) {
    return Container(
      width: ScreenUtil.getInstance().setWidth(375.0),
      child: InkWell(onTap: () {}, child: Image.network(product['image'])),
    );
  }

  Widget _firstRow() {
    return Row(
      children: <Widget>[
        _productItem(productList[0]),
        Column(
          children: <Widget>[
            _productItem(productList[1]),
            _productItem(productList[2]),
          ],
        ),
      ],
    );
  }

  Widget secondRow() {
    return Row(
      children: <Widget>[
        _productItem(productList[3]),
        _productItem(productList[4]),
      ],
    );
  }
}
