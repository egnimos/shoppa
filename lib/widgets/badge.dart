import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final Color color;
  final String value;

  //construct
  Badge({
    @required this.child, 
    @required this.color, 
    @required this.value,
    });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: <Widget>[
        child,

        Positioned(
          right: 12,
          left: 19,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: color
            ),

            constraints: BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),

            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
              )
            ),
          ),
        )
      ],
    );
  }
}