import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import './cart_screen.dart';
import '../providers/cart.dart';
import '../widgets/app_drawers.dart';
import '../providers/products.dart';


enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen  extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen > {

  var _showFavoritesOnly = false;
  var _isInit = true;
  var _isLoaded = false;

  // @override
  // void initState() {

  //   // Provider.of<Products>(context).fetchAndSetProducts();
  //   // Future.delayed(Duration.zero).then((_) {
  //   //   Provider.of<Products>(context).fetchAndSetProducts();
  //   // });
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoaded = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
      setState(() {
        _isLoaded =false;
      });
      });

    }

    _isInit = false;
    
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shoppa'),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
              color: Theme.of(context).accentColor,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
),
          ),

          //pop up menu button for selecting the favorite button
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  
                  _showFavoritesOnly = true;
                }else{

                  _showFavoritesOnly = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(child: Text('Favourites'), value: FilterOptions.Favorites,),
              PopupMenuItem(child: Text('Show All'), value: FilterOptions.All,),
            ],
          ),
        ],
      ),

      drawer: AppDrawer(),

      body: _isLoaded ? Center(
        child: CircularProgressIndicator(),
        ) : ProductsGrid(_showFavoritesOnly)

    );

  }


}