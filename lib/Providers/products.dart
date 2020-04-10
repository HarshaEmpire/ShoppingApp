import 'package:flutter/cupertino.dart';
import '../models/http_exception.dart';
import './product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './auth.dart';
class Products with ChangeNotifier {
  String _authToken;
  String _userId;
  
  set authToken(List<String> value) {
    _authToken = value[0];
    _userId=value[1];

  }
 
  List<Product> _items=[];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favourites {
    return items.where((tx) => tx.isFavourite == true).toList();
  }

  Future<void> addProduct(Product prod) async {
    final url = "https://dev-truth-268220.firebaseio.com/products.json?auth=$_authToken";
    try {
      final res = await http.post(url,
          body: json.encode({
            'title': prod.title,
            'price': prod.price,
            'description': prod.description,
            'imageUrl': prod.imageUrl,
            'creatorId':_userId,
          }));
      Product newProd = Product(
          title: prod.title,
          imageUrl: prod.imageUrl,
          description: prod.description,
          id: json.decode(res.body)["name"],
          price: prod.price);
      _items.add(newProd);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> fetchAndSetProducts([bool flag=false]) async {
    var filter=flag?'&orderBy="creatorId"&equalTo="$_userId"':'';
    var url = 'https://dev-truth-268220.firebaseio.com/products.json?auth=$_authToken'+filter;
    try {
      List<Product> allProd=[];
      final res = await http.get(url);
      var result = json.decode(res.body) as Map<String, dynamic>;
      if(result==null)
        return;

      url="https://dev-truth-268220.firebaseio.com/favourites/$_userId.json?auth=$_authToken";
      final facResponse=await http.get(url);
      final facData=json.decode(facResponse.body);

      result.forEach((prodId, prodData) {
        allProd.add(Product(
          id: prodId,
          title: prodData["title"],
          description: prodData["description"],
          imageUrl: prodData["imageUrl"],
          price: prodData["price"],
          isFavourite: facData==null?false:facData[prodId]??false,
        ));
      });
      _items=allProd;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> updateProduct(String id, Product prod) async {
    var index = _items.indexWhere((tx) {
      return tx.id == id;
    });
    final url = "https://dev-truth-268220.firebaseio.com/products/$id.json?auth=$_authToken";
    await http.patch(url,body:json.encode({
      "title":prod.title,
      "price":prod.price,
      "description":prod.description,
      "imageUrl":prod.imageUrl,

    }));
    _items[index] = prod;
    notifyListeners();
  }

  Future<void> delete(String id) async {
    var index = _items.indexWhere((tx) {
      return tx.id == id;
    });
    var item=_items[index];
    _items.removeAt(index);
    notifyListeners();
    final url = "https://dev-truth-268220.firebaseio.com/products/$id.json?auth=$_authToken";
      final res=await http.delete(url);
      if(res.statusCode>=400){
        _items.insert(index,item);
        notifyListeners();
        throw HttpException("Something Went Wrong");
      }
      item=null;
  }
}
