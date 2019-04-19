import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../provide/detail_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../provide/cart.dart';
import '../../router/application.dart';

class DetailBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var goodsInfo =
        Provide.value<DetailInfoProvide>(context).goodsInfo.data.goodInfo;
    var goodsId = goodsInfo.goodsId;
    var goodsName = goodsInfo.goodsName;
    var count = 1;
    var price = goodsInfo.presentPrice;
    var images = goodsInfo.image1;
    return Container(
      width: ScreenUtil.getInstance().setWidth(750),
      color: Colors.white,
      height: ScreenUtil.getInstance().setHeight(100),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () {
              Application.router.navigateTo(context, '/');
            },
            child: Container(
              width: ScreenUtil.getInstance().setWidth(110),
              alignment: Alignment.center,
              child: Icon(
                Icons.shopping_cart,
                size: 40.0,
                color: Colors.red,
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await Provide.value<CartProvide>(context)
                  .save(goodsName, goodsId, count, price, images);
            },
            child: Container(
                color: Colors.green,
                width: ScreenUtil.getInstance().setWidth(320.0),
                alignment: Alignment.center,
                child: Text('加入购物车',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil.getInstance().setSp(40)))),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              color: Colors.red,
              width: ScreenUtil.getInstance().setWidth(320.0),
              alignment: Alignment.center,
              child: Text(
                '立即购买',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil.getInstance().setSp(40),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
