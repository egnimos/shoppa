import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../providers/orders.dart' show Order;
import '../widgets/order_item.dart';
import '../widgets/app_drawers.dart';

class OrderScreen extends StatefulWidget {

  static const routeName = '/order';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isInit = true;
  var _isLoaded = false;


  // Future<void> _fetchOrderList() async{

    
  // }

  @override
  void didChangeDependencies() {
    
    if (_isInit) {

      setState(() {
        _isLoaded = true;
      });

      Provider.of<Order>(context).fetchOrderList().then((_) {
        setState(() {
          _isLoaded = false;
        });
      });
      
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),

      drawer: AppDrawer(),
      
      body: _isLoaded ? Center(

        child: CircularProgressIndicator(),
        
      ): ListView.builder(
        itemCount: orderData.order.length,
        itemBuilder: (ctx, i) => OrderItem(
          orderData.order[i]
        ),
      ),
    );
  }
}