import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kokylive/helper/echo.dart';
import 'package:kokylive/helper/images_path.dart';
import 'package:kokylive/helper/shared_pref.dart';
import 'package:kokylive/ui/home/home_controller.dart';
import 'package:kokylive/ui/login/login_page.dart';

class SplashImageAnimation extends StatefulWidget {
  @override
  _SplashImageAnimationState createState() => _SplashImageAnimationState();
}

class _SplashImageAnimationState extends State<SplashImageAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  String navigatorId;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    animation = new CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: animation.value,
      child: Image.asset(
        kLogo,
        width: 250,
        height: 250,
      ),
    );
  }

  init() async {
    YemenyPrefs pref = YemenyPrefs();

//    String language = await pref.getLanguage();
    String userToken = await pref.getToken();
    bool skip = await pref.getSkipAuth();
//    bool firstTime = await pref.getFirstTimeVisit();

//    if (language != null) context.locale = Locale(language);

//    if (language == null) {
//      navigatorId = SelectLangController.id;
//    } else
      if (userToken != null) {
      Echo('userToken $userToken');
      navigatorId = HomeController.id;
    } else if (skip == true) {
      Echo('skip $skip');
      navigatorId = HomeController.id;
    }
//      else if (firstTime == true) {
//      Echo('firstTime $firstTime');
//      navigatorId = OnBoardingPage.id;
//    }
      else {
      Echo('else');
      navigatorId = LoginController.id;
    }

    startTime();
  }

  startTime() {
    var _duration = new Duration(milliseconds: 2500);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushNamedAndRemoveUntil(
        context, navigatorId, (Route<dynamic> route) => false);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
