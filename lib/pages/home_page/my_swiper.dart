import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluro/fluro.dart';
import '../../router/application.dart';

class MySwiper extends StatelessWidget {
  final List swiperList;
  MySwiper({Key key, this.swiperList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.getInstance().setHeight(250.0),
      width: ScreenUtil.getInstance().setWidth(750.0),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return new InkWell(
            child: Image.network(
              "${swiperList[index]['image']}",
              fit: BoxFit.fill,
            ),
            onTap: () {
              Application.router.navigateTo(
                  context, "/detail?id=${swiperList[index]['goodsId']}",
                  transition: TransitionType.fadeIn);
            },
          );
        },
        itemCount: swiperList.length,
        pagination: SwiperPagination(),
        control: SwiperControl(),
        autoplay: true,
      ),
    );
  }
}
