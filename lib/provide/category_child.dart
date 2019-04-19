import 'package:flutter/material.dart';
import '../model/catrgory_model.dart';

class CategoryChild with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0;
  String categoryId = '4';
  String categorySubId = '';
  int page = 1;
  String noMoreText = '刷新完成';
  void getCategoryChild(List<BxMallSubDto> list, String id) {
    categoryId = id;
    childIndex = 0;
    page = 1;
    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '';
    all.mallSubName = '全部';
    all.mallCategoryId = '0000001';
    all.comments = null;
    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }

  void changeChildIndex(int index, String subId) {
    page = 1;
    noMoreText = '刷新完成';
    childIndex = index;
    categorySubId = subId;
    notifyListeners();
  }

  void increasePage() {
    page++;
  }

  void changeText(String text) {
    noMoreText = text;
    notifyListeners();
  }
}
