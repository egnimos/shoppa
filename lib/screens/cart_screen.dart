import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawers.dart';
import '../providers/orders.dart';
import '../providers/cart.dart' show Cart;//taking out the only one feature in the cart.dart provider class "WHICH IS Cart Class"
import '../widgets/cart_item.dart' ;


class CartScreen extends StatelessWidget {

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<Cart>(context);
  

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),

      drawer: AppDrawer(),

      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: <Widget>[
                  Text(
                    'Total Price:',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),

                  // SizedBox(width: 10,),
                  
                  
               
                  Chip(
                    label: Padding(
                      padding: EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text('\$${cart.totalAmount.toStringAsFixed(2)}', 
                        style: TextStyle(
                          color: Theme.of(context).primaryTextTheme.title.color),
                        ),
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    ),
                  
                  
                    Spacer(),

                    OrderNowButton(cart: cart )
                ],),
            ),
          ),

          //list of the product in the cart
          SizedBox(height: 10,),

          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount, //as itemCount returns the items.length// 
              itemBuilder: (ctx, i) => CartItem(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,
              ),
            ),
          ),

        ],
      ),
    );
  }
  
}


//new widget of ordering the cart items

class OrderNowButton extends StatefulWidget {
  const OrderNowButton({
    Key key,
    @required this.cart,
  
  }) : super(key: key);

  final Cart cart;


  @override
  _OrderNowButtonState createState() => _OrderNowButtonState();
}

class _OrderNowButtonState extends State<OrderNowButton> {


  var _isloading = false;

  @override
  Widget build(BuildContext context) {

    return FlatButton(

      child: _isloading ? CircularProgressIndicator() :Text('Order Now'),
      onPressed: widget.cart.totalAmount <= 0 ? null : ()  async{
        try {
        setState(() {
          _isloading = true;
        });
        await Provider.of<Order>(context, listen: false).addOrder(
          widget.cart.items.values.toList(), 
          widget.cart.totalAmount,
          );

          widget.cart.clear();

          setState(() {
            _isloading = false;
          });
        }catch(error) {

          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to order'),
            ),
          );
          
        }

        

        
      },
    );
  }
}