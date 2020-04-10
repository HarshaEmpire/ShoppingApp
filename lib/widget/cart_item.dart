import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String productId;
  final Function change; 
  CartItem({this.id,this.title,this.price,this.quantity,this.productId,this.change});
  @override
  Widget build(BuildContext context) {
    print("hello");
    return Dismissible(
      key:ValueKey(id),
      background: Container(
        margin: EdgeInsets.symmetric(vertical: 40,horizontal: 10),
        alignment: Alignment.centerLeft,
        child: Icon(Icons.delete,color: Colors.white,),
        color: Theme.of(context).errorColor,
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (dir){
        // Provider.of<Cart>(context,listen: false).removeItem(productId);
        change(productId);
      },
      confirmDismiss: (_){
        return showDialog(context: context,builder: (ctx)=>
          AlertDialog(title: Text("confirm to remove"),
          content: Text("Do u wanna remove the item"),
          actions: <Widget>[
            FlatButton(onPressed: (){
                Navigator.of(ctx).pop(false);
              }, 
              child: Text("No")
            ),
            FlatButton(onPressed: (){
                Navigator.of(ctx).pop(true);
              }, 
              child: Text("Yes"),
            ),            
          ],) 
        );
      },
      child:  Card(
        margin: EdgeInsets.symmetric(vertical: 40,horizontal: 10),
        child: Padding(padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              child:Padding(padding: EdgeInsets.all(5),child: FittedBox(child:Text("\$${price}"),),),
            ),
            title: Text(title),
            subtitle: Text("total: \$${price*quantity}"),
            trailing: Text("${quantity} x"),
          ),
        ),      
      ),
    );
  }
}