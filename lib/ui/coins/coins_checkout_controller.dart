import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/echo.dart';
import 'package:kokylive/helper/shared_pref.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/models/route_argument.dart';
import 'package:kokylive/ui/home/home_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CoinsCheckoutController extends StatefulWidget {
  static const String id = 'CoinsCheckoutController';
  final RouteArgument args;

  CoinsCheckoutController({this.args});

  @override
  _CoinsCheckoutControllerState createState() =>
      _CoinsCheckoutControllerState();
}

class _CoinsCheckoutControllerState extends State<CoinsCheckoutController> {
  bool _loading = false;
  bool _success = false;
  String userId = '';
  bool _showPaymentUrl = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  void getUserId() async {
    YemenyPrefs pref = YemenyPrefs();
    int id = await pref.getUserId();
    userId = id.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: _showPaymentUrl
            ? userId.isEmpty
                ? Container(
                    child: Text('error'),
                  )
                : WebView(
                    initialUrl:
                        'http://kokylive.com/Buy-Package/$userId/${widget.args.id}',
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },
                    navigationDelegate: (NavigationRequest request) async {
                      if (request.url.contains('success') ||
                          request.url.contains('Success')) {
                        Echo(
                            'http://kokylive.com/Buy-Package/$userId/${widget.args.id}');
                        setState(() {
                          _success = true;
                          _showPaymentUrl = false;
                        });
//                    try {
//                      String status = await networkBuyCoin(widget.args.id, context);
//                      if (status == 'success') {
//                        setState(() {
//                          _success = true;
//                        });
//                      }
//                    } catch (status) {
//                      if (status == 'network') {
//                        YemSnackBar().showNoInternetConnection(scaffoldKey: _scaffoldKey);
//                      } else if (status == 'json') {
//                        YemSnackBar().showServerErrorConnection(scaffoldKey: _scaffoldKey);
//                      } else {
//                        YemSnackBar().showSnackBarMessage(text: status, scaffoldKey: _scaffoldKey);
//                      }
//                      setState(() {
//                        _loading = false;
//                      });
//                    }
                        return NavigationDecision.prevent;
                      }
                      print('allowing navigation to $request');
                      return NavigationDecision.navigate;
                    },
                    onPageStarted: (String url) {
                      print('Page started loading: $url');
                    },
                    onPageFinished: (String url) {
                      print('Page finished loading: $url');
                    },
                    gestureNavigationEnabled: true,
                  )
            : _success
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 120,
                        color: Colors.green,
                      ),
                      SizedBox(height: 10),
                      Text(YemString().successPlaceAnOrder),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: double.infinity,
                          // ignore: deprecated_member_use
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  HomeController.id, (route) => false);
                            },
                            child: Text(
                              YemString().backToHome,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : _loading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${widget.args.param}',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                      Text('Coins'),
                                    ],
                                  ),
                                ),
                                Divider(),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${widget.args.heroTag}\$',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                      Text('Price'),
                                    ],
                                  ),
                                ),
                                Divider(),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                width: double.infinity,
                                // ignore: deprecated_member_use
                                child: ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      _showPaymentUrl = true;
                                    });
                                  },
                                  child: Text(
                                    YemString().payment,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
      ),
    );
  }
}
