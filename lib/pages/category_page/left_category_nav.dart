import 'package:flutter/material.dart';
import '../../service/service_method.dart';
import 'dart:convert';
import '../../model/catrgory_model.dart';
import '../../model/category_goods_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/category_child.dart';
import '../../provide/category_goods.dart';

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
