import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite=false;
  Product({this.id,this.title,this.description,this.price,this.imageUrl,this.isFavourite=false});

  Future<void> toggle(String token,String userId) async {
    var used= isFavourite;
    final url = "https://dev-truth-268220.firebaseio.com/favourites/$userId/$id.json?auth=$token";
    isFavourite=!isFavourite;
    notifyListeners();
    try{
      // print("kela");
      final res=await http.put(url,body: json.encode(
      isFavourite
      ));
      if(res.statusCode>=400){
        isFavourite=!isFavourite;
        notifyListeners();
        throw HttpException("done");
    }
    }
    catch(err){
      // print("kela");
      throw HttpException("error");
    }
  }
}