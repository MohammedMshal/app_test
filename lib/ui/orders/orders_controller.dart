import 'package:flutter/material.dart';
import 'package:kokylive/elements/CircularLoadingWidget.dart';
import 'package:kokylive/elements/no_internet_conn.dart';
import 'package:kokylive/elements/server_error.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/network_models/response_my_orders.dart';
import 'package:kokylive/repository/my_orders_request.dart';

class OrdersController extends StatefulWidget {
  static const id = '/OrdersController';

  @override
  _OrdersControllerState createState() => _OrdersControllerState();
}

class _OrdersControllerState extends State<OrdersController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(YemString().myOrders),
          centerTitle: true,
        ),
        body: FutureBuilder<List<SingleOrder>>(
//          key: GlobalKey(),
          future: networkGetMyOrders(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0)
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    SingleOrder singleOrder = snapshot.data[index];
                    return Card(
                      margin: EdgeInsets.all(16),
                      elevation: 4,
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: singleRowText(YemString().orderNumber, '${singleOrder.id}'),
                            ),
                            singleRowText(YemString().package, '${singleOrder.package}'),
                            singleRowText(YemString().coins, '${singleOrder.coins}'),
                            singleRowText(YemString().cost, '${singleOrder.cost}'),
                            singleRowText(YemString().status, '${singleOrder.status}'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              else
                return Center(
                  child: Text(YemString().empty),
                );
            }
            if (snapshot.hasError) {
              if (snapshot.error == null) {
                return ServerErrorWidget(refresh: () {
                  setState(() {});
                });
              }
              if (snapshot.error == 'network') {
                return NoInternetConnection(refresh: () {
                  setState(() {});
                });
              }
              if (snapshot.error == 'json') {
                return ServerErrorWidget(refresh: () {
                  setState(() {});
                });
              }
              return Text(' ${snapshot.error.toString()}');
            } else
              return Center(
                  child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: CircularLoadingWidget(),
              ));
//        return HomePageShimmer();
          },
        ),
      ),
    );
  }

  Widget singleRowText(String title, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(flex: 4, child: Text(title, style: TextStyle(color: Colors.black))),
          Flexible(flex: 6, child: Text(text, style: TextStyle(color: Colors.black))),
        ],
      ),
    );
  }
}
