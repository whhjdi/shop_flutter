import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/cart.dart';
import './cart_page/cart_item.dart';
import './cart_page/cart_bottom.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('购物车'),
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: _getCartInfo(context),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              List cartList = Provide.value<CartProvide>(context).cartList;
              if (snapshot.hasData && cartList != null) {
                return Stack(
                  children: <Widget>[
                    Provide<CartProvide>(
                      builder: (context, child, provide) {
                        List cartList = provide.cartList;
                        return ListView.builder(
                          itemCount: cartList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CartItem(cartList[index]);
                          },
                        );
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: CartBottom(),
                    ),
                  ],
                );
              } else {
                return Text('正在加载');
              }
            },
          ),
        ));
  }

  Future _getCartInfo(BuildContext context) async {
    await Provide.value<CartProvide>(context).getCartInfo();
    return '123';
  }
}
