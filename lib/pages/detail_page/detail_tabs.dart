import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../provide/detail_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailInfoProvide>(
      builder: (context, child, data) {
        var isLeft = Provide.value<DetailInfoProvide>(context).isLeft;
        return Container(
          margin: EdgeInsets.only(top: 10.0),
          child: Row(
            children: <Widget>[
              tabLeft(context, isLeft),
              tabRight(context, isLeft),
            ],
          ),
        );
      },
    );
  }

  Widget tabLeft(BuildContext context, bool isLeft) {
    return InkWell(
      onTap: () {
        if (!isLeft) {
          Provide.value<DetailInfoProvide>(context).changeLeftAndRight(true);
        }
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil.getInstance().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
                width: 1.0, color: isLeft ? Colors.red : Colors.black12),
          ),
        ),
        child: Text('详情'),
      ),
    );
  }

  Widget tabRight(BuildContext context, bool isLeft) {
    return InkWell(
      onTap: () {
        if (isLeft) {
          Provide.value<DetailInfoProvide>(context).changeLeftAndRight(false);
        }
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil.getInstance().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
                width: 1.0, color: !isLeft ? Colors.red : Colors.black12),
          ),
        ),
        child: Text('评论'),
      ),
    );
  }
}
