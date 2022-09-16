// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/strings.dart';

class ServerErrorWidget extends StatelessWidget {
  final Function refresh;

  ServerErrorWidget({this.refresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(YemString().serverError),
          SizedBox(height: 8),
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
