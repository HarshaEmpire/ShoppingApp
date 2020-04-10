import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        AppBar(
          title: Text("Ur Friend"),
        ),
        Divider(),
        ListTile(
          trailing: Icon(Icons.shop),
          title: Text("Shop"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(
              "/",
              arguments: {},
            );
          },
        ),
        Divider(),
        ListTile(
          trailing: Icon(Icons.payment),
          title: Text("Order page"),
          onTap: () {
            Navigator.of(context).pushNamed(
              "/orders",
              arguments: {},
            );
          },
        ),
        Divider(),
        ListTile(
          trailing: Icon(Icons.toc),
          title: Text("Your Products"),
          onTap: () {
            Navigator.of(context).pushNamed("/yourProducts", arguments: {});
          },
        ),
        Divider(),
        ListTile(
          trailing: Icon(Icons.exit_to_app),
          title: Text("Logout"),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed("/");
            Provider.of<Auth>(context, listen: false).logout();
          },
        ),
        Divider(),
      ],
    ));
  }
}
