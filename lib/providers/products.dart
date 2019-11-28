import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';

class Products with ChangeNotifier {

  List<Product> _items = [
     Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),

  ];

  //get the items in the list

  List<Product> get items {

    return [..._items];
  }

  List<Product> get favorites {

    return _items.where((prodFav) => prodFav.isFavorite).toList();
  }


  ///listing the product of the particular ID
  productDetail(String id) {
    return items.firstWhere((prod) => prod.id == id);
  }


  //add product in the list
  void addProduct(Product product) {

    const url = 'https://shoppa-1ac80.firebaseio.com/products.json';
    http.post(url, body: json.encode({
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'isFavorite': product.isFavorite,
    }),


    )

    .then((response) {

      print(json.decode(response.body));

       final newProduct = Product(
      title: product.title,
      price: product.price,
      description: product.description,
      imageUrl: product.imageUrl,
      id: json.decode(response.body) ['name'],
    );

    // _items.add(newProduct);

    _items.insert(0, newProduct);
    // items add(value)
    notifyListeners();
  

    });
  }

   

  Product findById(String productId) {
    return items.firstWhere((prod) => prod.id == productId);
  }



//update Product in the list......
  void updateProduct(String id, Product newProduct) {

    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    }else {
      print('...');
    }


  }


//Delete Public.....
  void deleteProduct(String id) {

    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }


}

