import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/catrgory_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        elevation: 0.0,
      ),
      body: Center(
        child: Row(
          children: <Widget>[LeftCategoryNav()],
        ),
      ),
    );
  }
}

class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List navList = [];

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
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil.getInstance().setHeight(80),
        width: ScreenUtil.getInstance().setWidth(150),
        // padding: EdgeInsets.only(left: 10, top: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 0.5, color: Colors.black12),
          ),
        ),
        child: Center(
          child: Text(
            navList[index].mallCategoryName,
            style: TextStyle(
              fontSize: ScreenUtil.getInstance().setSp(26),
            ),
          ),
        ),
      ),
    );
  }

  void _getCategory() async {
    var res = await getCategoryPage();
    var data = json.decode(res.toString());
    CategoryModel categoryList = CategoryModel.fromJson(data);
    setState(() {
      navList = categoryList.data;
    });
  }
}
