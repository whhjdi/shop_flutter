import 'package:flutter/material.dart';
import '../../service/service_method.dart';
import 'dart:convert';
import '../../model/catrgory_model.dart';
import '../../model/category_goods_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/category_child.dart';
import '../../provide/category_goods.dart';

class RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Provide<CategoryChild>(
        builder: (context, child, currentCategoryChild) {
          return Container(
            width: ScreenUtil.getInstance().setWidth(600),
            height: ScreenUtil.getInstance().setHeight(80),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1.0,
                  color: Colors.black12,
                ),
              ),
              color: Colors.white,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: currentCategoryChild.childCategoryList.length,
              itemBuilder: (context, index) {
                return _rightInkWell(
                    index, currentCategoryChild.childCategoryList[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _rightInkWell(int index, BxMallSubDto item) {
    bool isClick = false;
    isClick = (index == Provide.value<CategoryChild>(context).childIndex)
        ? true
        : false;
    return InkWell(
      onTap: () {
        if (!isClick) {
          Provide.value<CategoryChild>(context)
              .changeChildIndex(index, item.mallSubId);
          _getMallGoodsList(item.mallSubId);
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style: TextStyle(
            fontSize: ScreenUtil.getInstance().setSp(30),
            color: isClick ? Colors.blue : Colors.black,
          ),
        ),
      ),
    );
  }

  void _getMallGoodsList(String categorySubId) async {
    var data = {
      'categoryId': Provide.value<CategoryChild>(context).categoryId,
      'categorySubId': categorySubId,
      'page': 1,
    };
    var res = await getMallGoods(data);
    var resData = json.decode(res.toString());
    CategoryGoodsList goodsList = CategoryGoodsList.fromJson(resData);
    final currentCategoryGoods =
        Provide.value<CategoryGoodsListProvide>(context);
    if (goodsList.data == null) {
      currentCategoryGoods.getCategoryGoodsList([]);
    } else {
      currentCategoryGoods.getCategoryGoodsList(goodsList.data);
    }
  }
}
