import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../provide/detail_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailExplain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10.0),
      width: ScreenUtil.getInstance().setWidth(750),
      padding: EdgeInsets.all(10.0),
      child: Text(
        '说明: > 极速送达 > 正品保障',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
