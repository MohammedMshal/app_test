import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/shared_pref.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/ui/home/home_controller.dart';
import 'package:kokylive/ui/login/login_page.dart';

class OnBoardingPage extends StatefulWidget {
  static const String id = "/onBoarding";

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) async {
    YemenyPrefs prefs = YemenyPrefs();
    prefs.setFirstTimeVisit(false);

    int userId = await prefs.getUserId();
    if (userId == null) {
      Navigator.of(context).pushReplacementNamed(LoginController.id);
    } else {
      Navigator.of(context).pushReplacementNamed(HomeController.id);
    }
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/img/$assetName.png', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: IntroductionScreen(
          key: introKey,
          pages: [
            PageViewModel(
              titleWidget: Text(
                YemString().walkThroughTitle1,
                style: TextStyle(color: AppColors().primaryColor()),
              ),
              body: YemString().walkThroughBody1,
              image: _buildImage('img_step1'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              titleWidget: Text(
                YemString().walkThroughTitle2,
                style: TextStyle(color: AppColors().primaryColor()),
              ),
              body: YemString().walkThroughBody2,
              image: _buildImage('img_step2'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              titleWidget: Text(
                YemString().walkThroughTitle3,
                style: TextStyle(color: AppColors().primaryColor()),
              ),
              body: YemString().walkThroughBody3,
              image: _buildImage('img_step3'),
              decoration: pageDecoration,
            ),
          ],
          onDone: () => _onIntroEnd(context),
          //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
          showSkipButton: true,
          skipFlex: 0,
          nextFlex: 0,

          skip: Text(YemString().skip),
          next: const Icon(Icons.arrow_forward),
          done: Text(YemString().gotIt,
              style: TextStyle(fontWeight: FontWeight.w600)),
          dotsDecorator: const DotsDecorator(
            size: Size(10.0, 10.0),
            color: Color(0xFFBDBDBD),
            activeSize: Size(22.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
        ),
      ),
    );
  }
}
