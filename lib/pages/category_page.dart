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
import './category_page/right_category_nav.dart';
import './category_page/left_category_nav.dart';
import './category_page/category_goods.dart';

class CategoryPage extends StatelessWidget {
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
                RightCategoryList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
