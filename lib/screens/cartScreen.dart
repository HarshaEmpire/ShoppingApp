import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/cart.dart' show Cart;
import '../widget/cart_item.dart';
import '../Providers/order.dart';
import '../Providers/products.dart';
class CartScreen extends StatelessWidget {
  Future<void> _onrefresh(context) async{
    try{
      await Provider.of<Products>(context,listen: false).fetchAndSetProducts();
    }
    catch(err){
      print(err);
    }
  }
  @override
  Widget build(BuildContext context) {
    var cart=Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: RefreshIndicator(
          onRefresh: (){return _onrefresh(context);},
          child: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Total",style: Theme.of(context).textTheme.title,),
                  Spacer(),
                  Chip(label: Text("\$${cart.totalCost}"),backgroundColor: Theme.of(context).primaryColor,)
                  ,FlatClick(cart: cart),
                ],
              ),
            ),
            Expanded(child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (_,idx)=>CartItem(id:cart.items.values.toList()[idx].id,title: cart.items.values.toList()[idx].title
              ,quantity: cart.items.values.toList()[idx].quantity,price: cart.items.values.toList()[idx].price,
              productId:cart.items.keys.toList()[idx],change:cart.removeItem,)

              )),
          ],
        ),
      ),
    );
  }
}

class FlatClick extends StatefulWidget {
  const FlatClick({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _FlatClickState createState() => _FlatClickState();
}

class _FlatClickState extends State<FlatClick> {
  
  var _isloading=false;
  @override
  Widget build(BuildContext context) {
    final scaffold=Scaffold.of(context);
    return FlatButton(
    onPressed: widget.cart.items.isEmpty || _isloading? null :
    (){
      setState(() {
        _isloading=true;
      });
      Provider.of<Orders>(context,listen: false).addOrder(widget.cart.totalCost, widget.cart.items.values.toList()).then((_){
        setState(() {
          _isloading=false;
        });
        widget.cart.clear();
      }).catchError((err){
        setState(() {
          _isloading=false;
        });
        scaffold.showSnackBar(SnackBar(content: Text("Try Again"),));
      });
      
    }, child: _isloading?CircularProgressIndicator(): Text("Order now"),textColor: Theme.of(context).primaryColor,);
  }
}