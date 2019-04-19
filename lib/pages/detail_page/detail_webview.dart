import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../provide/detail_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailWebview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var goodsDetails = Provide.value<DetailInfoProvide>(context)
        .goodsInfo
        .data
        .goodInfo
        .goodsDetail;
    return Provide<DetailInfoProvide>(
      builder: (context, child, val) {
        var isLeft = Provide.value<DetailInfoProvide>(context).isLeft;
        if (isLeft) {
          return Container(
            child: Html(data: goodsDetails),
          );
        } else {
          return Container(
            width: ScreenUtil().setWidth(750),
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text('还没有评论呢!'),
          );
        }
      },
    );
  }
}
