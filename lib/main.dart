import 'package:flutter/material.dart';
import './pages/index_page.dart';
import 'package:provide/provide.dart';
import './provide/counter.dart';
import './provide/category_child.dart';
import './provide/category_goods.dart';
import 'package:fluro/fluro.dart';
import './router/application.dart';
import './router/routes.dart';
import './provide/detail_info.dart';
import './provide/cart.dart';
import './provide/index.dart';

void main() {
  final providers = Providers()
    ..provide(Provider.function((context) => CategoryChild()))
    ..provide(Provider.function((context) => CategoryGoodsListProvide()))
    ..provide(Provider.function((context) => DetailInfoProvide()))
    ..provide(Provider.function((context) => CartProvide()))
    ..provide(Provider.function((context) => CurrentIndexProvide()))
    ..provide(Provider.function((context) => Counter(0)));

  runApp(ProviderNode(
    providers: providers,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routes.configueRoutes(router);
    Application.router = router;

    return Container(
      child: MaterialApp(
        title: '沐雪',
        onGenerateRoute: Application.router.generator,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.red,
        ),
        home: IndexPage(),
      ),
    );
  }
}
