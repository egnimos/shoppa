import 'package:flutter/material.dart';

class CartItem {

  final String id;
  final String title;
  final double price;
  final int quantity;

  //construct
  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity,
  });
  
}

//using the mixins
class  Cart with ChangeNotifier{
  
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items}; //creating the copy of the 
  }

  //counting the number of the items present in the cart.....
  int get itemCount {
    return _items.length;
  }

  //total price of the each cart item
  double get totalAmount {
    var total = 0.0;

    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });

    return total;
  }

/*
adding the item in the cart if it is not in the cart
OR
if it is in the cart then update the quantity
*/

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      //change Quantity
      _items.update(productId, (existingCartItem) => CartItem(
        id: existingCartItem.id,
        title: existingCartItem.title,
        price: existingCartItem.price + existingCartItem.price,
        quantity: existingCartItem.quantity + 1,
      ),
      );
      
    }else{
      _items.putIfAbsent(productId, () => CartItem(
        id: DateTime.now().toString(),
        title: title,
        price: price,
        quantity: 1,
      ),);
      notifyListeners();
    }


  }

  void removeItem(String productId) {

     _items.remove(productId);
     notifyListeners();

  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId].quantity > 1) {
      _items.update(productId, (existingCartItem) => CartItem(
        id: existingCartItem.id,
        price: existingCartItem.price,
        title: existingCartItem.title,
        quantity: existingCartItem.quantity - 1,
      ),);
    }else {
      _items.remove(productId);
    }
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}