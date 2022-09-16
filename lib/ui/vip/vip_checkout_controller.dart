// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kokylive/elements/YemSnackBar.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/shared_pref.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/models/route_argument.dart';
import 'package:kokylive/network_models/response_membership_stickers.dart';
import 'package:kokylive/repository/buy_sticker_request.dart';
import 'package:kokylive/ui/home/home_controller.dart';

class VipCheckoutController extends StatefulWidget {
  static const String id = 'VipCheckoutController';
  final RouteArgument args;

  VipCheckoutController({this.args});

  @override
  _VipCheckoutControllerState createState() => _VipCheckoutControllerState();
}

class _VipCheckoutControllerState extends State<VipCheckoutController> {
  bool _loading = false;
  bool _success = false;
  String userId = '';
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    MembershipSticker membershipSticker = widget.args.param;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: _success
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
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(HomeController.id, (route) => false);
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CachedNetworkImage(
                                    width: 70,
                                    height: 70,
                                    imageUrl: membershipSticker.image.isNotEmpty ? membershipSticker.image : '',
                                    errorWidget: (context, url, error) {
                                      return CircularProgressIndicator();
                                    },
                                    placeholder: (context, url) {
                                      return CircularProgressIndicator();
                                    },
                                  ),
                                  Text('Sticker'),
                                ],
                              ),
                            ),
                            Divider(),
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${membershipSticker.cost} coin',
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                  Text('Price'),
                                ],
                              ),
                            ),
                            Divider(),
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${membershipSticker.days}',
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                  Text('Days'),
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
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _loading = true;
                                });
                                try {
                                  String status = await networkBuySticker(widget.args.id);
                                  if (status == 'success') {
                                    setState(() {
                                      _success = true;
                                    });
                                  } else {
                                    YemSnackBar().showSnackBarMessage(text: status, scaffoldKey: _scaffoldKey);
                                  }
                                } catch (status) {
                                  if (status == 'network') {
                                    YemSnackBar().showNoInternetConnection(scaffoldKey: _scaffoldKey);
                                  } else if (status == 'json') {
                                    YemSnackBar().showServerErrorConnection(scaffoldKey: _scaffoldKey);
                                  } else {
                                    YemSnackBar().showSnackBarMessage(text: status, scaffoldKey: _scaffoldKey);
                                  }
                                }
                                setState(() {
                                  _loading = false;
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
