// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:kokylive/helper/strings.dart';

class YemSnackBar {
  void showServerErrorConnection(
      {Function function, @required GlobalKey<ScaffoldState> scaffoldKey}) {
    SnackBar snackBar;
    if (function != null)
      snackBar = SnackBar(
        content: Text(YemString().errorServerConnection),
        duration: Duration(minutes: 30),
        action: SnackBarAction(
          onPressed: function,
          label: YemString().refreshPage,
        ),
      );
    else
      snackBar = SnackBar(
        content: Text(YemString().errorServerConnection),
        duration: Duration(seconds: 3),
      );
  }

  void showNoInternetConnection(
      {Function function, @required GlobalKey<ScaffoldState> scaffoldKey}) {
    SnackBar snackBar;
    if (function != null)
      snackBar = SnackBar(
        content: Text(YemString().noInternetConnection),
        duration: Duration(seconds: 12),
        action: SnackBarAction(
          onPressed: function,
          label: YemString().refreshPage,
        ),
      );
    else
      snackBar = SnackBar(
        content: Text(YemString().errorServerConnection),
        duration: Duration(seconds: 3),
      );
  }

  void showSnackBarMessage(
      {@required String text, @required GlobalKey<ScaffoldState> scaffoldKey}) {
    SnackBar snackBar = SnackBar(
      content: Text(text),
      duration: Duration(seconds: 9),
    );
  }
}
