// ignore_for_file: deprecated_member_use

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/echo.dart';
import 'package:kokylive/network_models/response_products.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'PaypalServices.dart';

class PaypalPayment extends StatefulWidget {
  final Function onFinish;
  final List<Product> listCartModel;
  final double totalCartAmount;

  PaypalPayment({this.onFinish, this.listCartModel, this.totalCartAmount});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String checkoutUrl;
  String executeUrl;
  String accessToken;
  PaypalServices services = PaypalServices();

  // you can change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();

        final transactions = getOrderParams();
        final res =
            await services.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      } catch (e) {
        Echo('exception: ' + e.toString());
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
      }
    });
  }

  // item name, price and quantity

  Map<String, dynamic> getOrderParams() {
    List items = [];

    widget.listCartModel.map((item) {
      items.add({
        "name": item.title,
        "quantity": item.quantity,
        "price": item.price * AppStrings.CURRENCY_USD_SAR,
        "currency": defaultCurrency["currency"]
      });
    }).toList();

    // checkout invoice details
    String totalAmount =
        '${widget.totalCartAmount * AppStrings.CURRENCY_USD_SAR}';
    String subTotalAmount =
        '${widget.totalCartAmount * AppStrings.CURRENCY_USD_SAR}';
    String shippingCost = '0';
    int shippingDiscountCost = 0;
//    String userFirstName = 'test';
//    String userLastName = 'buyer';
//    String addressCity = '';
//    String addressStreet = '';
//    String addressZipCode = '11426';
//    String addressCountry = 'Egypt';
//    String addressState = '';
//    String addressPhoneNumber = '+01011661056';

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount": (shippingDiscountCost).toString()
            }
          },
          "description": "Payemnt for motors.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
//            if (isEnableShipping &&
//                isEnableAddress)
//              "shipping_address": {
//                "recipient_name": userFirstName +
//                    " " +
//                    userLastName,
//                "line1": addressStreet,
//                "line2": "",
//                "city": addressCity,
//                "country_code": addressCountry,
//                "postal_code": addressZipCode,
//                "phone": addressPhoneNumber,
//                "state": addressState
//              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    print(checkoutUrl);

    if (checkoutUrl != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors().primaryColor(),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              if (payerID != null) {
                services
                    .executePayment(executeUrl, payerID, accessToken)
                    .then((id) {
                  Echo('success $id');
                  widget.onFinish(id.toString());
//                  Navigator.of(context).pop();
                });
              } else {
                Navigator.of(context).pop();
              }
              Navigator.of(context).pop();
            }
            if (request.url.contains(cancelURL)) {
              Navigator.of(context).pop();
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
  }
}
