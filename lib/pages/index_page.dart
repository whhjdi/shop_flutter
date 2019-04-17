import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './home_page.dart';
import './category_page.dart';
import './cart_page.dart';
import './user_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.home),
      title: Text('首页'),
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.search),
      title: Text('分类'),
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.shopping_cart),
      title: Text('购物车'),
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.person),
      title: Text('我的'),
    )
  ];

  final List tabContent = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    UserPage(),
  ];

  int currentIndex = 0;
  var currentPage;

  @override
  void initState() {
    currentPage = tabContent[currentIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: bottomTabs,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            currentPage = tabContent[currentIndex];
          });
        },
      ),
      body: currentPage,
    );
  }
}
