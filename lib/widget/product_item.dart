import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Providers/product.dart';
import '../Providers/cart.dart';
import '../Providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String _id;
  // final String _title;
  // final String _url;
  // ProductItem(this._id,this._title,this._url);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final token = auth.token;
    final userId = auth.userId;
    final scaffold = Scaffold.of(context);
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
          child: GestureDetector(
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                fadeInCurve: Curves.fastOutSlowIn,
                placeholder: AssetImage('assets/images/product-placeholder.png'),
                image: NetworkImage(
                  product.imageUrl,
                ),
                fit: BoxFit.cover,
              ),
            ),
            onTap: () => Navigator.of(context)
                .pushNamed('/ProductDetail', arguments: {"id": product.id}),
          ),
          footer: GridTileBar(
            leading: Consumer<Product>(
                builder: (_, product, child) => IconButton(
                    icon: Icon(product.isFavourite
                        ? Icons.favorite
                        : Icons.favorite_border),
                    onPressed: () {
                      product.toggle(token, userId).catchError((err) {
                        print("hello");
                        scaffold.showSnackBar(SnackBar(
                          content: Text(
                            "some error occored",
                            textAlign: TextAlign.center,
                          ),
                        ));
                      });
                    })),
            title: Text(
              product.title,
              softWrap: true,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.black54,
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                print(product.id);
                print(product.price);
                cart.addItem(product.id, product.title, product.price);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Item Added"),
                    duration: Duration(
                      seconds: 1,
                    ),
                    action: SnackBarAction(
                        label: "Undo",
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        }),
                  ),
                );
              },
            ),
          )),
    );
  }
}
