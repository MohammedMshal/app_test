import 'package:flutter/material.dart';
import 'package:kokylive/database/cart_database_crud.dart';
import 'package:kokylive/elements/YemSnackBar.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/echo.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/models/cart_model_provider.dart';
import 'package:kokylive/network_models/response_products.dart';
import 'package:kokylive/repository/checkout_request.dart';
import 'package:provider/provider.dart';

import 'paypal_payment.dart';

class PaymentController extends StatefulWidget {
  static const String id = 'payment';

  @override
  _PaymentControllerState createState() => _PaymentControllerState();
}

class _PaymentControllerState extends State<PaymentController> {
  CartDatabaseCRUD cartDatabaseCRUD = new CartDatabaseCRUD();
  List<Product> listCartModel = [];
  bool _loading = false;
  bool _success = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var cartModelProvider = Provider.of<CartModelProvider>(context);
    CartDatabaseCRUD cartDatabaseCRUD = new CartDatabaseCRUD();

    listCartModel.clear();
    double totalCartAmount = 0;
    cartModelProvider.cartModel.map((singleCartItem) {
      totalCartAmount += (singleCartItem.price * singleCartItem.quantity);
      listCartModel.add(singleCartItem);
    }).toList();

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: AppColors().primaryColor(),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          centerTitle: true,
          title: Text(
            YemString().payment,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Builder(builder: (BuildContext ctx0) {
          return Container(
              width: MediaQuery.of(context).size.width,
              child: Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _success
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 80,
                              color: Colors.green,
                            ),
                            SizedBox(height: 8),
                            Text(YemString().successPlaceAnOrder),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 16),
                            singleRowText(YemString().productsCount,
                                '${listCartModel.length}'),
                            SizedBox(height: 8),
                            singleRowText(
                                YemString().total, '$totalCartAmount'),
                            SizedBox(height: 16),
                            if (_loading) LinearProgressIndicator(),
                            if (!_loading)
                              Container(
                                width: double.infinity,
                                // ignore: deprecated_member_use
                                child: ElevatedButton(
                                  onPressed: () {
                                    // make PayPal payment

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext ctx) =>
                                              PaypalPayment(
                                                onFinish: (number) async {
                                                  // payment done
                                                  Echo('success2 ${number}');
                                                  setState(() {
                                                    _loading = true;
                                                  });
                                                  try {
                                                    bool status =
                                                        await networkCheckout(
                                                            cartModelProvider);
                                                    Echo('status');
                                                    if (status) {
                                                      cartDatabaseCRUD.delete(
                                                          context: context);
                                                      setState(() {
                                                        _success = true;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        _loading = false;
                                                      });
                                                      YemSnackBar()
                                                          .showSnackBarMessage(
                                                              text: '$number',
                                                              scaffoldKey:
                                                                  _scaffoldKey);
                                                    }
                                                  } catch (error) {
                                                    if (error == 'network') {
                                                      YemSnackBar()
                                                          .showNoInternetConnection(
                                                              function: () {
                                                                setState(() {
                                                                  _loading =
                                                                      false;
                                                                });
                                                              },
                                                              scaffoldKey:
                                                                  _scaffoldKey);
                                                    } else if (error ==
                                                        'json') {
                                                      YemSnackBar()
                                                          .showServerErrorConnection(
                                                              function: () {
                                                                setState(() {
                                                                  _loading =
                                                                      false;
                                                                });
                                                              },
                                                              scaffoldKey:
                                                                  _scaffoldKey);
                                                    } else {
                                                      setState(() {
                                                        _loading = false;
                                                      });
                                                      YemSnackBar()
                                                          .showSnackBarMessage(
                                                              text: '$error',
                                                              scaffoldKey:
                                                                  _scaffoldKey);
                                                    }
                                                  }
                                                },
                                                listCartModel: listCartModel,
                                                totalCartAmount:
                                                    totalCartAmount,
                                              )),
                                    );
                                  },
                                  child: Text(
                                    'Pay with Paypal',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                ),
              ));
        }),
      ),
    );
  }

  Widget singleRowText(String title, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                  flex: 5,
                  child: Text(
                    title,
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.start,
                  )),
              Flexible(
                  flex: 8,
                  child: Text(
                    text,
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.end,
                  )),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
