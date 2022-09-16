import 'package:flutter/material.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/strings.dart';

class FavoriteController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.favorite_border,
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
