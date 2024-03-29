import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopa/models/http_exception.dart';

import './product.dart';

class Products with ChangeNotifier {

  List<Product> _items = [
    //  Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),

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


  Future<void> fetchAndSetProducts() async{

    const url = 'https://shoppa-1ac80.firebaseio.com/products.json';

    try {

      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'],
        ));
      });

      _items = loadedProducts;
      notifyListeners();
      
    } catch (error) {
      // print(error);
      throw error;

    }

  }


  //add product in the list
  Future<void> addProduct(Product product) async {

    const url = 'https://shoppa-1ac80.firebaseio.com/products.json';

    
    try{

    final response = await http.post(url, body: json.encode({ //post returns the future 

      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'isFavorite': product.isFavorite,
    }),

  );

   // .then((response) { //then method also returns the future

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
  

    }catch(error) {

      print(error);
      throw error;

    }

   

    // }).catchError((error) {

    // });

  }

   

//Find the product By Id.......
  Product findById(String productId) {
    return items.firstWhere((prod) => prod.id == productId);
  }



//update Product in the list......
 Future<void> updateProduct(String id, Product newProduct) async{

    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    if (prodIndex >= 0) {
      final url = 'https://shoppa-1ac80.firebaseio.com/products/$id.json';

      try {

        http.patch(url, body: json.encode({

        'title': newProduct.title,
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
        'price': newProduct.price,

      }),);

      _items[prodIndex] = newProduct;
      notifyListeners();
        
      } catch (error) {

        print(error);
        throw error;

      }
     
    }else {
      print('...');
    }


  }


//Delete Public.....
  Future<void> deleteProduct(String id) async{

    final url = 'https://shoppa-1ac80.firebaseio.com/products/$id.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);

      if(response.statusCode >= 400) {
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw HttpException('could not delete Product');
      }else {

      existingProduct = null;
      }
  
  }


}

