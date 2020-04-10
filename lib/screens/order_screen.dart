import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/order.dart' show Orders;
import '../widget/order_item.dart';
class OrderScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // var orderData=Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Order"),  
      ),
      body:FutureBuilder(future: Provider.of<Orders>(context,listen:false).fetchAndSet(),
        builder: (_,data){
        if(data.connectionState==ConnectionState.waiting){
          return Center(child:CircularProgressIndicator());
        }
        else{
          if(data.error==null){
            return Consumer<Orders>(builder: (ctx,orderData,_)=>
            ListView.builder(
              itemCount: orderData.getOrders.length,
              itemBuilder:(ctx,idx)=> OrderItem(orderData.getOrders[idx])
            ),);
          }
          else{
            return Center(child:Text("Stay Cool Try Again"),);
          }
        }
      })
    );
  }
}