// ignore_for_file: deprecated_member_use

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:kokylive/elements/CircularLoadingWidget.dart';
import 'package:kokylive/elements/edit_text.dart';
import 'package:kokylive/elements/no_internet_conn.dart';
import 'package:kokylive/elements/server_error.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/models/main_provider_model.dart';
import 'package:kokylive/network_models/response_get_coin_price.dart';
import 'package:kokylive/repository/coin_price_request.dart';
import 'package:kokylive/repository/withdrawal_request.dart';
import 'package:kokylive/ui/home/home_controller.dart';
import 'package:provider/provider.dart';

class WithdrawalController extends StatefulWidget {
  static const String id = 'WithdrawalController';

  @override
  _WithdrawalControllerState createState() => _WithdrawalControllerState();
}

class _WithdrawalControllerState extends State<WithdrawalController> {
  bool _loading = false;
  bool _success = false;

  @override
  Widget build(BuildContext context) {
    MainProviderModel providerModel =
        Provider.of<MainProviderModel>(context, listen: false);
    return SafeArea(
      child: Scaffold(
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
                    child: CircularLoadingWidget(),
                  )
                : FutureBuilder<ResponseGetCoinPrice>(
                    future: networkGetCoinPrice(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(YemString().coin),
                            EditText(
                              enable: false,
                              value: '${providerModel.profileData.coins}',
                              autoValidate: false,
                              updateFunc: () {},
                              validateFunc: () {},
                              iconData: Icons.monetization_on,
                            ),
                            SizedBox(height: 12),
                            Text(YemString().coinPrice),
                            EditText(
                              enable: false,
                              value: '${snapshot.data.data}',
                              autoValidate: false,
                              updateFunc: () {},
                              validateFunc: () {},
                              iconData: Icons.monetization_on,
                            ),
                            SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () async {
                                if (providerModel.profileData.coins > 0) {
                                  setState(() {
                                    _loading = true;
                                  });
                                  String status = await networkWithdrawal(
                                      '${providerModel.profileData.coins}',
                                      context);
                                  if (status == 'success') {
                                    setState(() {
                                      _success = true;
                                    });
                                  } else {
                                    setState(() {
                                      _loading = false;
                                    });
                                  }
                                } else {
                                  Flushbar(
                                    backgroundColor: Colors.red,
                                    title: '',
                                    message: '0 coin!',
                                    flushbarPosition: FlushbarPosition.TOP,
                                    duration: Duration(seconds: 1),
                                  )..show(context);
                                }
                              },
                              child: Text(
                                YemString().withdrawalNow,
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
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
}
