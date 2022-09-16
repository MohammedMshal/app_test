import 'package:flutter/material.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/strings.dart';

class NoInternetConnection extends StatelessWidget {
  final Function refresh;

  NoInternetConnection({this.refresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(YemString().noInternetConnection),
          SizedBox(height: 8),
          // ignore: deprecated_member_use
          ElevatedButton(
            onPressed: refresh,
            child: Text(
              YemString().retry,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
