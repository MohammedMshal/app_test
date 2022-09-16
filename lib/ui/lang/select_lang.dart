import 'package:easy_localization/easy_localization.dart' as localize;
import 'package:flutter/material.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/images_path.dart';
import 'package:kokylive/helper/shared_pref.dart';
import 'package:kokylive/ui/home/home_controller.dart';
import 'package:kokylive/ui/login/login_page.dart';
import 'package:kokylive/ui/onboard/on_boarding_page.dart';

class SelectLangController extends StatefulWidget {
  static const id = "/lang";

  @override
  _SelectLangControllerState createState() => _SelectLangControllerState();
}

class _SelectLangControllerState extends State<SelectLangController> {
  bool selectArabic = true;
  bool selectEnglish = false;

  String btnText = 'المتابعة';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'splash_hero',
                  child: Image.asset(
                    kLogo,
                    height: 240,
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  margin: EdgeInsets.all(4),
                  elevation: 4,
                  color: AppColors().primaryColor(),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey, width: 0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: CheckboxListTile(
                            activeColor: Colors.white,
                            checkColor: AppColors().primaryColor(),
                            title: const Text(
                              'اللغة العربية',
                              style: TextStyle(color: Colors.white),
                            ),
                            value: selectArabic,
                            onChanged: (bool value) {
                              setState(() {
                                selectArabic = !selectArabic;
                                selectEnglish = !selectArabic;
                                btnText = 'المتابعة';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(4),
                  elevation: 4,
                  color: AppColors().primaryColor(),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey, width: 0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: CheckboxListTile(
                            activeColor: Colors.white,
                            checkColor: AppColors().primaryColor(),
                            title: const Text('English',
                                style: TextStyle(color: Colors.white)),
                            value: selectEnglish,
                            onChanged: (bool value) {
                              setState(() {
                                selectEnglish = !selectEnglish;
                                selectArabic = !selectEnglish;
                                btnText = 'Continue';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                // ignore: deprecated_member_use
                ElevatedButton(
                  onPressed: () {
                    setState(() async {
                      YemenyPrefs pref = YemenyPrefs();
                      if (selectArabic) {
                        context.locale = Locale('ar');
                        localize.EasyLocalization.of(context).locale =
                            Locale('ar');
                        pref.setLanguage("ar");
                        navigateToNextPage();
                      }
                      if (selectEnglish) {
                        context.locale = Locale('en');
                        localize.EasyLocalization.of(context).locale =
                            Locale('en');
                        pref.setLanguage("en");
                        navigateToNextPage();
                      }
                    });
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
                    child: Text(
                      btnText,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navigateToNextPage() async {
    bool goToWalkThroughScreen = false;
    bool goToLoginScreen = false;
    YemenyPrefs pref = YemenyPrefs();

    bool isItFirstTime = await pref.getFirstTimeVisit();
    int userId = await pref.getUserId();

    goToWalkThroughScreen = isItFirstTime != null ? isItFirstTime : true;
    goToLoginScreen = userId == null ? true : false;

    if (goToWalkThroughScreen)
      Navigator.of(context).pushReplacementNamed(OnBoardingPage.id);
    else if (goToLoginScreen)
      Navigator.of(context).pushReplacementNamed(LoginController.id);
    else
      Navigator.of(context).pushReplacementNamed(HomeController.id);
  }
}
