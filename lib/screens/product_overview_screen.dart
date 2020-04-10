
import 'package:flutter/material.dart';
import 'package:shop/widget/app_drawer.dart';
import 'package:shop/widget/badge.dart';
import '../widget/product_grid.dart';
import '../Providers/cart.dart';
import '../Providers/products.dart';
import 'package:provider/provider.dart';
class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _init=true;
  var _isloading=false;
  @override
  void didChangeDependencies(){
    if(_init==true){
      setState(() {
        _isloading=true;
      });
      Provider.of<Products>(context,listen: false).fetchAndSetProducts().then((_){
        setState(() {
          _isloading=false;
        });
      })
      .catchError((err)=>print(err));
    }
    _init=false;

  }
  var _isFavouriteSelected=false;
  
  @override
  Widget build(BuildContext context) {
    // var _productClass=Provider.of<Products>(context,listen: false);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Products"),
        actions: <Widget>[
          PopupMenuButton(itemBuilder: (_)=>[
            PopupMenuItem(child: Text("only favourites"),value: 0,),
            PopupMenuItem(child: Text("all Items"),value:1,),
          ],
          onSelected: (idx){
            if(idx==0){
              setState((){
                _isFavouriteSelected=true;
              });
            }
            else{
              setState((){
                _isFavouriteSelected=false;
              });

            }
          },),
          Consumer<Cart>(builder: (_,cart,ch)=>
            Badge(child: ch,value: cart.itemCount.toString(),),
            child: IconButton(icon: Icon(Icons.shopping_cart),
            onPressed: (){
              Navigator.of(context).pushNamed('/cart',arguments: {});
            }),
          )
        ],
      ),
      body: _isloading?Center(child: CircularProgressIndicator(),) :
      ProductGrid(_isFavouriteSelected));
  }
}

