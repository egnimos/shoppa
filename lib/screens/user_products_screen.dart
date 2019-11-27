import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawers.dart';
import '../screens/edit_product_screen.dart';


class UserProductsScreens extends StatelessWidget {
  static const routeName = '/user-content';

  @override
  Widget build(BuildContext context) {

    final productData = Provider.of<Products>(context);

    return Scaffold(

      appBar: AppBar(
        title: Text('Your Products'),

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {

              Navigator.of(context).pushNamed(EditProductScreen.routeName);

            },
          ),
        ],
      ),

      drawer: AppDrawer(),

      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: productData.items.length,
          itemBuilder: (_, i) => Column(
            children: <Widget>[
              UserProductItem(
                productData.items[i].id,
                productData.items[i].title, 
                productData.items[i].imageUrl,
                ),

                Divider(),

            ],
          ),
        ),
      ),

    );
  }
  
}