import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cart_model.dart';

class CartProvide with ChangeNotifier {
  String cartString = "[]";
  List<CartModel> cartList = [];
  double allPrice = 0;
  int allGoodsCount = 0;
  bool allChecked = true;
  Future save(goodsName, goodsId, count, price, images) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    var temp = cartString == null ? [] : json.decode(cartString.toString());
    List<Map> tempList = (temp as List).cast();
    var isHave = false;
    int ival = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == goodsId) {
        tempList[ival]['count'] = item['count'] + 1;
        isHave = true;
      }
      ival++;
    });
    if (!isHave) {
      Map<String, dynamic> newGoods = {
        'goodsId': goodsId,
        'goodsName': goodsName,
        'count': count,
        'price': price,
        'images': images,
        'isCheck': true,
      };
      tempList.add(newGoods);
      cartList.add(CartModel.fromJson(newGoods));
    }

    cartString = json.encode(tempList).toString();
    await prefs.setString('cartInfo', cartString);
    print('save success');
  }

  void clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cartInfo');
    notifyListeners();
  }

  getCartInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    cartList = [];
    if (cartString == null) {
      cartList = [];
    } else {
      List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
      allPrice = 0;
      allGoodsCount = 0;
      allChecked = true;
      print(tempList);
      tempList.forEach((item) {
        if (item['isCheck']) {
          allPrice += (item['count'] * item['price']);
          allGoodsCount += item['count'];
        } else {
          print('没有全选');
          allChecked = false;
        }
        cartList.add(CartModel.fromJson(item));
      });
    }

    notifyListeners();
  }

  deleteOne(goodsId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();

    int tempIndex = 0;
    int delIndex = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == goodsId) {
        delIndex = tempIndex;
      }
      tempIndex++;
    });
    tempList.removeAt(delIndex);
    cartString = json.encode(tempList).toString();
    await prefs.setString('cartInfo', cartString);
    await getCartInfo();
    notifyListeners();
  }

  changeCheckState(cartItem) async {
    //读
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    print('change check');
    int tempIndex = 0;
    int changeIndex = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == cartItem.goodsId) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });

    //存
    tempList[changeIndex] = cartItem.toJson();
    allChecked = tempList.every((item) {
      print('是否选中${item}');
      return item['isCheck'];
    });
    print('判断是否应该全选');
    print(allChecked);
    cartString = json.encode(tempList).toString();
    await prefs.setString('cartInfo', cartString);
    await getCartInfo();
    notifyListeners();
  }

  changeAllCheckState(bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    print('change all check');
    List<Map> newList = [];
    for (var item in tempList) {
      var newItem = item;
      newItem['isCheck'] = val;
      newList.add(newItem);
    }
    print('是否全选');
    print(val);
    cartString = json.encode(newList).toString(); //形成字符串
    await prefs.setString('cartInfo', cartString); //进行持久化
    await getCartInfo();
    notifyListeners();
  }

  addOrReduceCount(cartItem, String todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    int tempIndex = 0;
    int changeIndex = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == cartItem.goodsId) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });
    if (todo == 'add') {
      cartItem.count++;
    } else if (cartItem.count > 1) {
      cartItem.count--;
    }
    tempList[changeIndex] = cartItem.toJson();
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString); //
    await getCartInfo();
  }
}
