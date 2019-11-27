import 'package:flutter/foundation.dart';

import './cart.dart';


class OrderItem {

  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  //construct
  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });

}


  class Order with ChangeNotifier {

    List<OrderItem> _order = []; //creating the empty list.......

    List<OrderItem> get order {  //creating the copy of the list....
      return [..._order];
    }


    void addOrder(List<CartItem> cartProducts, double total ) {  //adding the order in the empty list of the "_order" properties

      _order.insert(0, OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
      );

      notifyListeners();

    }
    
  }


  
