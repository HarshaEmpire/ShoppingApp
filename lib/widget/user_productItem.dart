import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String url;
  UserProductItem({this.title,this.url,this.id});
  @override
  Widget build(BuildContext context) {
    final scaffold=Scaffold.of(context);
    return Card(
      margin: EdgeInsets.all(10),
      child:ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(url),),
        title: Text(title),
        trailing: Container(width: 100,
          child: Row(children: <Widget>[
            IconButton(icon: Icon(Icons.edit,color: Theme.of(context).primaryColor,), 
            onPressed: (){
              Navigator.of(context).pushNamed("/editProduct",arguments: id.toString());
            }),
            IconButton(icon: Icon(Icons.delete,color: Theme.of(context).errorColor,), 
            onPressed: () async {
              try{
                await Provider.of<Products>(context,listen: false).delete(id);}
              catch(err){
                scaffold.showSnackBar(SnackBar(content: Text("Some Error Occured",textAlign: TextAlign.center,)));
              }
            }),
          ],),
        ),
      )

      
    );
  }
}