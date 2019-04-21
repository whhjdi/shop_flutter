import 'package:flutter/material.dart';
import '../../service/service_method.dart';
import 'dart:convert';
import '../../model/category_goods_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/category_child.dart';
import '../../provide/category_goods.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../router/application.dart';

class RightCategoryList extends StatefulWidget {
  @override
  _RightCategoryListState createState() => _RightCategoryListState();
}

class _RightCategoryListState extends State<RightCategoryList> {
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
          print(err);
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
