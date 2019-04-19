import 'package:flutter/material.dart';
import '../model/category_goods_list.dart';

class CategoryGoodsListProvide with ChangeNotifier {
  List<CategoryGoods> categoryGoods = [];

  void getCategoryGoodsList(List<CategoryGoods> list) {
    categoryGoods = list;
    notifyListeners();
  }

  void getMoreCategoryGoodsList(List<CategoryGoods> list) {
    categoryGoods.addAll(list);
    notifyListeners();
  }
}
