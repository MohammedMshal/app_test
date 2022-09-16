// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/strings.dart';

class MessageErrorWidget extends StatelessWidget {
  final Function refresh;
  final String message;

  MessageErrorWidget({this.message, this.refresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(message),
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
