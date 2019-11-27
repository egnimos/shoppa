import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';



class ProductDetailScreen extends StatelessWidget {

  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {

    final productId = ModalRoute.of(context).settings.arguments as String; //taking the product ID
    final loadedData = Provider.of<Products>(context).productDetail(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedData.title),),
      body: SingleChildScrollView(
              child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedData.imageUrl,
                fit: BoxFit.cover,
                ),
            ),

            SizedBox(height: 10,),

            Text(
              'Price: \$${loadedData.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                ),
            ),

            SizedBox(height: 10,),

            Container(
              child: Text(
                'Description',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w700
                ),
                textAlign: TextAlign.center,
              ),
              ),

            SizedBox(height: 20,),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 10,),
              width: double.infinity,
              child: Text(
                loadedData.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}