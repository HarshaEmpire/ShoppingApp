
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/product.dart';
import '../Providers/products.dart';
import '../widget/product_item.dart';
class ProductGrid extends StatelessWidget {
  final bool _isfavourite;
  ProductGrid(this._isfavourite);


  @override
  Widget build(BuildContext context) {
    
    var _productClass=Provider.of<Products>(context);
    List<Product> _products;
    if(_isfavourite)
      _products=_productClass.favourites;
    else
      _products=_productClass.items;
    return GridView.builder(
      padding: const EdgeInsets.all(5),
      itemCount: _products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
      childAspectRatio: 2/3,
      crossAxisSpacing: 30,
      mainAxisSpacing: 50), 
      itemBuilder: (ctx,idx)=>ChangeNotifierProvider.value(
        value: _products[idx],
        child:ProductItem(),
      ),
    
    );
  }
}