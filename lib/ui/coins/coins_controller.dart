import 'package:flutter/material.dart';
import 'package:kokylive/models/route_argument.dart';
import 'package:kokylive/network_models/response_coins.dart';
import 'package:kokylive/repository/coins_request.dart';

import 'coins_checkout_controller.dart';

class CoinsController extends StatelessWidget {
  static const id = "coins";

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<List<Coin>>(
          future: networkGetCoins(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              if (snapshot.data.length > 0) {
                return Column(
                  children: [
                    SizedBox(height: 20),
                    ...snapshot.data.map((singleItem) {
                      return GestureDetector(
                        onTap: () async {
                          RouteArgument args = new RouteArgument(id:'${singleItem.id}' ,param: singleItem.amount,heroTag: '${singleItem.cost}');
                          Navigator.of(context).pushNamed(CoinsCheckoutController.id,arguments:args );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey, width: 0.2)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset('assets/img/ic_coin.png', height: 36, width: 36),
                                ),
                                Text('${singleItem.amount} coin'),
                                Text('${singleItem.cost}\$'),
                                Icon(Icons.arrow_forward_ios),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              }else{
                return Center(child: CircularProgressIndicator(),);
              }
            } else  {
              return Center(child: CircularProgressIndicator(),);
            }

          },
        )
      ),
    );
  }
}


