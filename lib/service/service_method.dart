import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';

Future request(url, {formData}) async {
  try {
    Response response;
    Dio dio = new Dio();
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    if (formData == null) {
      response = await dio.post(url);
    } else {
      response = await dio.post(url, data: formData);
    }
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('请求失败');
    }
  } catch (err) {
    throw Exception(err);
  }
}

//获取首页
Future getHomePage() async {
  var formData = {'lon': '115.02133', 'lat': '35.76123'};
  var url = servicePath['homePage'];
  var res = await request(url, formData: formData);
  return res;
}

//热卖
Future getHomePageHot(formData) async {
  var url = servicePath['homePageHot'];
  var res = await request(url, formData: formData);
  return res;
}

//分类
Future getCategoryPage() async {
  var url = servicePath['categoryPage'];
  var res = await request(url);
  return res;
}

//分类商品
Future getMallGoods(formData) async {
  var url = servicePath['mallGoods'];
  var res = await request(url, formData: formData);
  return res;
}

//商品详情
Future getGoodsDetail(formData) async {
  var url = servicePath['goodsDetail'];
  var res = await request(url, formData: formData);
  return res;
}
