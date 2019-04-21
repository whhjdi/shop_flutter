import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluro/fluro.dart';
import '../../router/application.dart';

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
          _firstRow(context),
          secondRow(context),
        ],
      ),
    );
  }

  Widget _productItem(BuildContext context, Map product) {
    return Container(
      width: ScreenUtil.getInstance().setWidth(375.0),
      child: InkWell(
          onTap: () {
            Application.router.navigateTo(
                context, "/detail?id=${product['goodsId']}",
                transition: TransitionType.fadeIn);
          },
          child: Image.network(product['image'])),
    );
  }

  Widget _firstRow(context) {
    return Row(
      children: <Widget>[
        _productItem(context, productList[0]),
        Column(
          children: <Widget>[
            _productItem(context, productList[1]),
            _productItem(context, productList[2]),
          ],
        ),
      ],
    );
  }

  Widget secondRow(context) {
    return Row(
      children: <Widget>[
        _productItem(context, productList[3]),
        _productItem(context, productList[4]),
      ],
    );
  }
}
