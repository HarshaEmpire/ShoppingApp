import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Providers/cart.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/screens/cartScreen.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/screens/order_screen.dart';
import 'package:shop/screens/user_product_screen.dart';
import './Providers/products.dart';
import './screens/product_detail_screen.dart';
import './screens/product_overview_screen.dart';
import './Providers/order.dart';
import './Providers/auth.dart';
import './screens/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products(),
            update: (_, auth, products) =>
                products..authToken = [auth.token, auth.userId],
          ),
          ChangeNotifierProvider.value(value: Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (_) => Orders(),
            update: (_, auth, orders) =>
                orders..authToken = [auth.token, auth.userId],
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, data, _) => MaterialApp(
            title: ("Shop"),
            theme: ThemeData(
                primarySwatch: Colors.pink,
                accentColor: Colors.amber,
                fontFamily: "Lato"),
            // home: ProductOverviewScreen(),
            initialRoute: "/",
            routes: {
              "/": (ctxx) => data.isAuthenticated == true
                  ? ProductOverviewScreen()
                  : FutureBuilder(
                      future: data.tryLoginAuto(),
                      builder: (ctx, snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
              "/productOverview": (ctxx) => ProductOverviewScreen(),
              "/ProductDetail": (ctxx) => ProductDetailScreen(),
              "/cart": (ctxx) => CartScreen(),
              "/orders": (ctxx) => OrderScreen(),
              "/yourProducts": (ctxx) => UserProductScreen(),
              "/editProduct": (ctxx) => EditProductScreen(),
            },
          ),
        ));
  }
}
