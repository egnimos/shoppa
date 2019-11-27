import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../providers/orders.dart' show Order;
import '../widgets/order_item.dart';
import '../widgets/app_drawers.dart';

class OrderScreen extends StatelessWidget {

  static const routeName = '/order';

  @override
  Widget build(BuildContext context) {

    final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),

      drawer: AppDrawer(),
      
      body: ListView.builder(
        itemCount: orderData.order.length,
        itemBuilder: (ctx, i) => OrderItem(
          orderData.order[i]
        ),
      ),
    );
  }
}