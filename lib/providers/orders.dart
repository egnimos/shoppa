import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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


   Future<void> addOrder(List<CartItem> cartProducts, double total ) async{  //adding the order in the empty list of the "_order" properties
      
      const url = 'https://shoppa-1ac80.firebaseio.com/orders.json';

      try{

      final response = await http.post(url, body:json.encode({

        'amount': total,
        'dateTime': DateTime.now().toIso8601String(),
        'products': cartProducts.map((cartpro) => { //epresented in the form of map cartItems
          'id': cartpro.id,
          'title': cartpro.title,
          'price': cartpro.price,
          'quantity': cartpro.quantity,
        } ).toList(),

      })
      );

      _order.insert(0, OrderItem(
        id: json.decode(response.body) ['name'],
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
      );

      notifyListeners();

    }catch(error) {

      print(error);
      throw error;

    }
   }


   //fetch the orders from the servers
   Future<void> fetchOrderList() async{

     const url = 'https://shoppa-1ac80.firebaseio.com/orders.json';

     try {
       
       final response = await http.get(url);
       final extractedData = json.decode(response.body) as Map<String, dynamic>;
       final List<OrderItem> loadedOrders = [];

       if (extractedData == null) {
         return;
       }

       extractedData.forEach((orderId, orderData) {
         loadedOrders.insert(0, OrderItem(
           id: orderId,
           dateTime: DateTime.parse(orderData['dateTime']),
           amount: orderData['amount'],
           products: (orderData['products'] as List<dynamic>).map((item) => CartItem(
             id: item['id'],
             title: item['title'],
             price: item['price'],
             quantity: item['quantity'],
           )).toList(),
         ));
       });

       _order = loadedOrders.reversed.toList();
       notifyListeners();

     } catch (error) {

       print(error);
       throw error;

     }

   }
    

  }//EOC


  
