import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/detail_info.dart';
import './detail_page/detail_top.dart';
import './detail_page/detail_explain.dart';
import './detail_page/detail_tabs.dart';
import './detail_page/detail_webview.dart';
import './detail_page/detail_bottom.dart';

class DetailsPage extends StatelessWidget {
  final String goodsId;
  DetailsPage(this.goodsId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('商品详情'),
      ),
      body: FutureBuilder(
        future: _getGoodInfo(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: <Widget>[
                Container(
                  child: ListView(
                    children: <Widget>[
                      DetailTop(),
                      DetailExplain(),
                      DetailTabs(),
                      DetailWebview(),
                      Text('加载完成：${goodsId}'),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: DetailBottom(),
                ),
              ],
            );
          } else {
            return Text('正在加载');
          }
        },
      ),
    );
  }

  Future _getGoodInfo(BuildContext context) async {
    await Provide.value<DetailInfoProvide>(context).getGoodsInfo(goodsId);
    print('${goodsId}');
    return '123';
  }
}
