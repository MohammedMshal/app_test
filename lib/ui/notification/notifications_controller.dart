import 'package:flutter/material.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/strings.dart';

class NotificationsController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.notifications_off,
          size: 90,
          color: AppColors().primaryColor(),
        ),
        Text(
          YemString().empty,
          style: TextStyle(fontSize: 22),
        ),
      ],
    );
  }
}
