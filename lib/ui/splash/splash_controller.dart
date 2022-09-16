import 'package:flutter/material.dart';
import 'package:kokylive/ui/splash/splash_image_animation.dart';

class SplashController extends StatelessWidget {
  static const String id = '/splash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(width: double.infinity),
          SplashImageAnimation(),
          SizedBox(width: double.infinity),
          CircularProgressIndicator(),
          SizedBox(width: double.infinity),
        ],
      ),
    );
  }
}
