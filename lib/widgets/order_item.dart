import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord ;//adding the suffix


class OrderItem extends StatefulWidget {

  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {

  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: <Widget>[
        ListTile(
          title: Text('\$${widget.order.amount}'),
          subtitle: Text(DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime),
          ),
          trailing: IconButton(
            icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more ),

            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            ),
        ),

        //widget in the expanded button
        if (_expanded)

          Container(
            height: min(widget.order.products.length * 20.0 + 100.0, 100),
            child: ListView(
              children: widget.order.products.map((prod) => Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: <Widget>[
                  Text(
                    prod.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ), 
                  ),

                  Text(
                    '\$${prod.price}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ), 
              ).toList(),
            ),
          ),  
        

      ],),
    );
  }
}