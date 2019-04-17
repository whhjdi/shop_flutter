import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('分类'),
      ),
    );
  }

  void getCategory() async {
    var res = await getCategoryPage();
    List<Map> categoryList =
        (json.decode(res.toString())['data'] as List).cast();
  }
}
