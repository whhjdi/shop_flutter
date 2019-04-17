import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';

//获取首页
Future getHomePage() async {
  try {
    Response response;
    Dio dio = new Dio();
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    var formData = {'lon': '115.02133', 'lat': '35.76123'};
    response = await dio.post(servicePath['homePage'], data: formData);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      print('失败');
      throw Exception('请求失败');
    }
  } catch (err) {
    return print(err);
  }
}
