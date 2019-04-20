import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/catrgory_model.dart';
import '../model/category_goods_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/category_child.dart';
import '../provide/category_goods.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../router/application.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '商品分类',
        ),
        backgroundColor: Colors.blue,
        // elevation: 0.0,
      ),
      body: Center(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[
                RightCategoryNav(),
                CategoryGoods(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Provide<CategoryChild>(
        builder: (context, child, currentCategoryChild) {
          return Container(
            width: ScreenUtil.getInstance().setWidth(600),
            height: ScreenUtil.getInstance().setHeight(80),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1.0,
                  color: Colors.black12,
                ),
              ),
              color: Colors.white,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: currentCategoryChild.childCategoryList.length,
              itemBuilder: (context, index) {
                return _rightInkWell(
                    index, currentCategoryChild.childCategoryList[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _rightInkWell(int index, BxMallSubDto item) {
    bool isClick = false;
    isClick = (index == Provide.value<CategoryChild>(context).childIndex)
        ? true
        : false;
    return InkWell(
      onTap: () {
        if (!isClick) {
          Provide.value<CategoryChild>(context)
              .changeChildIndex(index, item.mallSubId);
          _getMallGoodsList(item.mallSubId);
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style: TextStyle(
            fontSize: ScreenUtil.getInstance().setSp(30),
            color: isClick ? Colors.blue : Colors.black,
          ),
        ),
      ),
    );
  }

  void _getMallGoodsList(String categorySubId) async {
    var data = {
      'categoryId': Provide.value<CategoryChild>(context).categoryId,
      'categorySubId': categorySubId,
      'page': 1,
    };
    var res = await getMallGoods(data);
    var resData = json.decode(res.toString());
    CategoryGoodsList goodsList = CategoryGoodsList.fromJson(resData);
    final currentCategoryGoods =
        Provide.value<CategoryGoodsListProvide>(context);
    if (goodsList.data == null) {
      currentCategoryGoods.getCategoryGoodsList([]);
    } else {
      currentCategoryGoods.getCategoryGoodsList(goodsList.data);
    }
  }
}

class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List navList = [];
  int navListIndex = 0;
  @override
  void initState() {
    _getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.getInstance().setWidth(150),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 1.0, color: Colors.black12),
        ),
      ),
      child: ListView.builder(
        itemCount: navList.length,
        itemBuilder: (context, index) {
          return _leftInkWellItem(index);
        },
      ),
    );
  }

  Widget _leftInkWellItem(int index) {
    final currentCategoryChild = Provide.value<CategoryChild>(context);
    bool isClick = false;
    isClick = (index == navListIndex) ? true : false;
    return InkWell(
      onTap: () {
        if (!isClick) {
          setState(() {
            navListIndex = index;
          });
          var childList = navList[index].bxMallSubDto;
          var categoryId = navList[index].mallCategoryId;
          currentCategoryChild.getCategoryChild(childList, categoryId);
          _getMallGoodsList(categoryId: categoryId);
        }
      },
      child: Container(
        height: ScreenUtil.getInstance().setHeight(80),
        width: ScreenUtil.getInstance().setWidth(150),
        // padding: EdgeInsets.only(left: 10, top: 20),
        decoration: BoxDecoration(
          color: isClick ? Colors.lightBlue : Colors.white,
          border: Border(
            bottom: BorderSide(width: 0.5, color: Colors.black12),
          ),
        ),
        child: Center(
          child: Text(
            navList[index].mallCategoryName,
            style: TextStyle(
              color: isClick ? Colors.white : Colors.black,
              fontSize: ScreenUtil.getInstance().setSp(26),
            ),
          ),
        ),
      ),
    );
  }

  void _getMallGoodsList({String categoryId}) async {
    var data = {
      'categoryId': categoryId == null ? '4' : categoryId,
      'categorySubId': '',
      'page': 1,
    };
    var res = await getMallGoods(data);
    var resData = json.decode(res.toString());
    CategoryGoodsList goodsList = CategoryGoodsList.fromJson(resData);
    final currentCategoryGoods =
        Provide.value<CategoryGoodsListProvide>(context);
    currentCategoryGoods.getCategoryGoodsList(goodsList.data);
  }

  void _getCategory() async {
    var res = await getCategoryPage();
    var data = json.decode(res.toString());
    CategoryModel categoryList = CategoryModel.fromJson(data);
    setState(() {
      navList = categoryList.data;
    });
    final currentCategoryChild = Provide.value<CategoryChild>(context);
    currentCategoryChild.getCategoryChild(
        categoryList.data[0].bxMallSubDto, categoryList.data[0].mallCategoryId);
    _getMallGoodsList();
  }
}

//分类商品列表
class CategoryGoods extends StatefulWidget {
  @override
  _CategoryGoodsState createState() => _CategoryGoodsState();
}

class _CategoryGoodsState extends State<CategoryGoods> {
  ScrollController scrollController = ScrollController();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();
  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvide>(
      builder: (context, child, currentCategoryGoods) {
        try {
          if (Provide.value<CategoryChild>(context).page == 1) {
            //滚动到开始状态
            scrollController.jumpTo(0.0);
          }
        } catch (err) {
          throw Error();
        }

        if (currentCategoryGoods.categoryGoods.length > 0) {
          return Expanded(
            child: Container(
              width: ScreenUtil.getInstance().setWidth(600),
              child: EasyRefresh(
                refreshFooter: ClassicsFooter(
                  key: _footerKey,
                  bgColor: Colors.white,
                  textColor: Colors.blue,
                  moreInfo: '正在加载',
                  moreInfoColor: Colors.blue,
                  noMoreText: Provide.value<CategoryChild>(context).noMoreText,
                  loadReadyText: '松开刷新',
                ),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: currentCategoryGoods.categoryGoods.length,
                  itemBuilder: (context, index) {
                    return _goodsDetail(
                        currentCategoryGoods.categoryGoods, index);
                  },
                ),
                loadMore: () async {
                  _getMoreGoodsList();
                },
              ),
            ),
          );
        } else {
          return Expanded(
            child: Center(
              child: Text('暂时没有商品哦~'),
            ),
          );
        }
      },
    );
  }

  void _getMoreGoodsList() async {
    Provide.value<CategoryChild>(context).increasePage();
    var data = {
      'categoryId': Provide.value<CategoryChild>(context).categoryId,
      'categorySubId': Provide.value<CategoryChild>(context).categorySubId,
      'page': Provide.value<CategoryChild>(context).page
    };
    var res = await getMallGoods(data);
    var resData = json.decode(res.toString());
    CategoryGoodsList goodsList = CategoryGoodsList.fromJson(resData);
    final currentCategoryGoods =
        Provide.value<CategoryGoodsListProvide>(context);
    if (goodsList.data == null) {
      Fluttertoast.showToast(
          msg: "已经到底了",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Provide.value<CategoryChild>(context).changeText('没有更多商品了');
    } else {
      currentCategoryGoods.getCategoryGoodsList(goodsList.data);
    }
  }

  Widget _goodsDetail(goodsList, index) {
    return InkWell(
        onTap: () {
          Application.router.navigateTo(
            context,
            "/detail?id=${goodsList[index].goodsId}",
          );
        },
        child: Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.black12),
              )),
          child: Row(
            children: <Widget>[
              _goodsImg(goodsList, index),
              _goodsText(goodsList, index),
            ],
          ),
        ));
  }

  Widget _goodsImg(goodsList, index) {
    return Container(
      width: ScreenUtil.getInstance().setWidth(200),
      child: Image.network(goodsList[index].image),
    );
  }

  Widget _goodsText(goodsList, index) {
    return Container(
        width: ScreenUtil.getInstance().setWidth(360),
        padding: EdgeInsets.only(left: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: ScreenUtil.getInstance().setWidth(360),
              child: Text(
                goodsList[index].goodsName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setSp(28),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              width: ScreenUtil().setWidth(380),
              child: Row(
                children: <Widget>[
                  Text(
                    '价格：￥${goodsList[index].presentPrice}',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: ScreenUtil.getInstance().setSp(28),
                    ),
                  ),
                  Text(
                    '${goodsList[index].oriPrice}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: ScreenUtil.getInstance().setSp(28),
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
