import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/products.dart';
import "../widget/user_productItem.dart";
import 'package:image_picker/image_picker.dart';

class UserProductScreen extends StatelessWidget {
  @override
  Future<void> _refreshProd(BuildContext context) async {
    await Provider.of<Products>(context,listen: false).fetchAndSetProducts(true);
  }
  Widget build(BuildContext context) {
    // var product = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed("/editProduct");
              })
        ],
      ),
      body: FutureBuilder(
              future: _refreshProd(context),
              builder: (ctx,snapshot)=>snapshot.connectionState==ConnectionState.waiting?
               Center(child: CircularProgressIndicator(),)
               :RefreshIndicator(onRefresh: (){return _refreshProd(context);},
              child: Consumer<Products>(builder: (ctxx,product,_) => Padding(
          padding: EdgeInsets.all(5),
          child: ListView.builder(
              itemCount: product.items.length,
              itemBuilder: (ctx, idx) => UserProductItem(
                    id:product.items[idx].id,
                    title: product.items[idx].title,
                    url: product.items[idx].imageUrl,
                  )),
        ),),
      ),
    ));
  }
}
