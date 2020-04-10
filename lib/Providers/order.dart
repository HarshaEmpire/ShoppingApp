


import 'package:flutter/material.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem{
  final String id;
  final double cost;
  final List<CartItem> cart;
  final DateTime date;

  OrderItem({this.id,this.cost,this.cart,this.date});
}

class Orders with ChangeNotifier{
  List<OrderItem> _orders=[];
  List<String> authToken;
  List<OrderItem> get getOrders{
    return [..._orders];
  }
  Future<void> fetchAndSet()async{
    final url = 'https://dev-truth-268220.firebaseio.com/orders/${authToken[1]}.json?auth=${authToken[0]}';
    List<OrderItem> lists=[];
    try{
    final res=await http.get(url);
    final response=json.decode(res.body) as Map<String,dynamic>;
    if(response==null)
      return;
    response.forEach((orderId,orderData){
      lists.add(OrderItem(id: orderId,cost: orderData["cost"],date:DateTime.parse(orderData["date"]),
      cart:(orderData["cart"] as List<dynamic>).map((tx){
        return CartItem(id: tx["id"],title: tx["title"],price: tx["price"],quantity: tx["quantity"]);
      }).toList()
      ));
    });
    _orders=lists;
    notifyListeners();
    }
    catch(err){
      throw err;
    }
  }

  Future<void> addOrder(double total,List<CartItem> items) async {
      final url = "https://dev-truth-268220.firebaseio.com/orders/${authToken[1]}.json?auth=${authToken[0]}";
      var date=DateTime.now();
      try{
      final res=await http.post(url,body:json.encode({
        "cost":total,
        "date":date.toIso8601String(),
        "cart":items.map((tx)=>
          {
            
            "id":tx.id,
            "title":tx.title,
            "quantity":tx.quantity,
            "price":tx.price,
          }
        ).toList(),

      }));
      _orders.add(OrderItem(id:json.decode(res.body)["name"],cost:total,cart:items,date:date,));
      notifyListeners();
      }
      catch(err){
        throw err;
      }
  }

}