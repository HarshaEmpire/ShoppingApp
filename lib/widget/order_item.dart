import 'package:flutter/material.dart';
import '../Providers/order.dart' as od;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final od.OrderItem _order;
  OrderItem(this._order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _isExpanded=false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: <Widget>[
        ListTile(
          title: Text("\$${widget._order.cost}"),
          subtitle: Text(DateFormat.yMMMMd().format(widget._order.date)),
          trailing: IconButton(icon: (!_isExpanded ?Icon(Icons.expand_more):Icon(Icons.expand_less)),
           onPressed: (){
            setState(() {
              _isExpanded=!_isExpanded;
            });
          } ),
        ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            constraints: BoxConstraints(
              minHeight: _isExpanded ? 60 : 0,
              maxHeight: _isExpanded ? 60 : 0,
            ),
            padding: EdgeInsets.all(10),
            height: 120,
            child: ListView(
              children: widget._order.cart.map((tx){
                return ListTile(
                  title:Text(tx.title,style: Theme.of(context).textTheme.title,),
                  trailing: Text("\$${tx.price} x ${tx.quantity}"),
                );
              }).toList(),
            ),
          )
      ],),
      
    );
  }
}