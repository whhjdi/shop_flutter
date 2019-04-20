import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/cart.dart';

class CartBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      color: Colors.white,
      width: ScreenUtil.getInstance().setWidth(750),
      child: Row(
        children: <Widget>[
          selectAllBtn(context),
          allPrice(context),
          payBtn(context),
        ],
      ),
    );
  }

  Widget selectAllBtn(BuildContext context) {
    return Provide<CartProvide>(
      builder: (context, child, provide) {
        return Container(
          child: Row(
            children: <Widget>[
              Checkbox(
                value: provide.allChecked,
                activeColor: Colors.red,
                onChanged: (bool val) {
                  provide.changeAllCheckState(val);
                },
              ),
              Text('全选'),
            ],
          ),
        );
      },
    );
  }

  Widget allPrice(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Provide<CartProvide>(builder: (context, child, provide) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  child: Text('合计:',
                      style: TextStyle(fontSize: ScreenUtil().setSp(30))),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text('￥${provide.allPrice}',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: Colors.red,
                      )),
                )
              ],
            );
          }),
          Container(
            width: ScreenUtil().setWidth(430),
            alignment: Alignment.centerRight,
            child: Text(
              '满10元免配送费，预购免配送费',
              style: TextStyle(
                  color: Colors.black38, fontSize: ScreenUtil().setSp(22)),
            ),
          )
        ],
      ),
    );
  }

  Widget payBtn(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      padding: EdgeInsets.only(left: 10),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(3.0)),
          child: Provide<CartProvide>(
            builder: (context, child, provide) {
              return Text(
                '结算(${provide.allGoodsCount})',
                style: TextStyle(color: Colors.white),
              );
            },
          ),
        ),
      ),
    );
  }
}
