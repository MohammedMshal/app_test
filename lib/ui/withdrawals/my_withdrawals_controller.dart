import 'package:flutter/material.dart';
import 'package:kokylive/elements/CircularLoadingWidget.dart';
import 'package:kokylive/elements/no_internet_conn.dart';
import 'package:kokylive/elements/server_error.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/network_models/response_my_withdrawals.dart';
import 'package:kokylive/repository/my_withdrawals_request.dart';
import 'package:kokylive/ui/withdrawals/withdraw_controller.dart';

class MyWithdrawalsController extends StatefulWidget {
  static const id = '/MyWithdrawalsController';

  @override
  _MyWithdrawalsControllerState createState() =>
      _MyWithdrawalsControllerState();
}

class _MyWithdrawalsControllerState extends State<MyWithdrawalsController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(YemString().myWithdrawals),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 16),
              // ignore: deprecated_member_use
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(WithdrawalController.id);
                },
                child: Text(
                  YemString().requestWithdrawal,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: FutureBuilder<List<SingleWithdrawal>>(
//          key: GlobalKey(),
                future: networkGetMyWithdrawals(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length > 0)
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          SingleWithdrawal singleWithdrawal =
                              snapshot.data[index];
                          return Card(
                            margin: EdgeInsets.all(16),
                            elevation: 4,
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    color: Colors.grey[300],
                                    child: singleRowText(
                                        YemString().orderNumber,
                                        '${singleWithdrawal.id}'),
                                  ),
                                  singleRowText(YemString().coinPrice,
                                      '${singleWithdrawal.coinPrice}'),
                                  singleRowText(YemString().coins,
                                      '${singleWithdrawal.coins}'),
                                  singleRowText(YemString().date,
                                      '${singleWithdrawal.date}'),
                                  singleRowText(YemString().status,
                                      '${singleWithdrawal.status}'),
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
          ],
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
          Flexible(
              flex: 4,
              child: Text(title, style: TextStyle(color: Colors.black))),
          Flexible(
              flex: 6,
              child: Text(text, style: TextStyle(color: Colors.black))),
        ],
      ),
    );
  }
}
