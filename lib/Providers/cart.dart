import 'package:flutter/material.dart';

class CartItem{
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({this.id,this.title,this.quantity,this.price});
}

class Cart with ChangeNotifier{
  Map<String,CartItem> _items={};
  Map<String,CartItem> get items{
    return {..._items};
  }

  int get itemCount{
    return _items.length;
  }
  double get totalCost{
    var total=0.0;
    _items.forEach((id,values){
      total+=values.quantity*values.price;
    });
    return total;
  }
  void addItem(String id,String title,double price){
    // final url = "https://dev-truth-268220.firebaseio.com/cart";
    
    if(_items.containsKey(id)){
      _items.update(id, (exist)=>CartItem(id:exist.id,title:exist.title,quantity: 
      exist.quantity+1,price: exist.price));
    }
    else{
      _items.putIfAbsent(id, ()=>CartItem(id:DateTime.now().toString(),title: title,price:
      price,quantity: 1,));
    }
    notifyListeners();

  }
  void removeItem(String id){
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String id){
    if(!_items.containsKey(id))
      return ;
    if(_items[id].quantity>1)
      _items.update(id, (prev)=>CartItem(id: prev.id,title: prev.title,price: prev.price
      ,quantity: prev.quantity-1));
    else
      _items.remove(id);
    notifyListeners();
  }

  void clear(){
    _items={};
    notifyListeners();
  }
}