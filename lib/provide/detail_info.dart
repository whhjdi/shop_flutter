import 'package:flutter/material.dart';
import '../model/goods_detail_model.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailInfoProvide with ChangeNotifier {
  GoodsDetailModel goodsInfo = GoodsDetailModel();
  bool isLeft = true;

  //切换tabBar
  void changeLeftAndRight(bool flag) {
    isLeft = flag;
    notifyListeners();
  }

  //获取数据
  Future getGoodsInfo(id) async {
    var formData = {'goodId': id};
    var res = await getGoodsDetail(formData);
    var newData = json.decode(res.toString());
    goodsInfo = GoodsDetailModel.fromJson(newData);
    notifyListeners();
  }
}
