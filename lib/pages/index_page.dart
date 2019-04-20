import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './home_page.dart';
import './category_page.dart';
import './cart_page.dart';
import './user_page.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/index.dart';

class IndexPage extends StatelessWidget {
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

  final List<Widget> tabContent = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Provide<CurrentIndexProvide>(
      builder: (context, child, provide) {
        int currentIndex = provide.currentIndex;
        return Scaffold(
            backgroundColor: Colors.grey[100],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: bottomTabs,
              currentIndex: currentIndex,
              onTap: (index) {
                provide.changeIndex(index);
              },
            ),
            body: IndexedStack(
              index: currentIndex,
              children: tabContent,
            ));
      },
    );
  }
}
