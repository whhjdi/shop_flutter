import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import './router_handle.dart';

class Routes {
  static String root = '/';
  static String detailsPage = '/detail';
  static void configueRoutes(Router router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      print('no router');
    });
    router.define(detailsPage, handler: detailsHandler);
  }
}
