import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/images_path.dart';
import 'package:kokylive/helper/shared_pref.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/models/main_provider_model.dart';
import 'package:kokylive/ui/about_policy/about_controller.dart';
import 'package:kokylive/ui/about_policy/policy_controller.dart';
import 'package:kokylive/ui/contact_us/contact_us_controller.dart';
import 'package:kokylive/ui/login/login_page.dart';
import 'package:kokylive/ui/profile/profile_screen.dart';
import 'package:provider/provider.dart';

import 'home_controller.dart';

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerItem> list = [];

  @override
  void initState() {
    super.initState();

    addDrawerList();
  }

  void addDrawerList() async {
    YemenyPrefs prefs = YemenyPrefs();
    String userToken = await prefs.getToken();
    bool loggedUser = userToken == null ? false : true;

    if (loggedUser)
      list.add(DrawerItem(
          title: YemString().myAccount,
          iconData: Icons.person,
          routeName: ProfileScreen.id));

    if (!loggedUser)
      list.add(DrawerItem(
          title: YemString().myAccount,
          iconData: Icons.person,
          routeName: LoginController.id));

    list.add(DrawerItem(
        title: YemString().home,
        iconData: Icons.home,
        routeName: null));
    list.add(DrawerItem(
        title: YemString().about,
        iconData: Icons.info_outline,
        routeName: AboutController.id));
    list.add(DrawerItem(
        title: YemString().policyAndTerms,
        iconData: Icons.short_text,
        routeName: PolicyController.id));
    list.add(DrawerItem(
        title: YemString().contactUs,
        iconData: Icons.contact_mail,
        routeName: ContactUs.id));
//    list.add(DrawerItem(
//        title: YemString().changeLanguage,
//        iconData: Icons.language,
//        routeName: null));
//    list.add(DrawerItem(
//        title: YemString().rateApp, iconData: Icons.star, routeName: null));
//    list.add(DrawerItem(
//        title: YemString().shareApp, iconData: Icons.share, routeName: null));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
              color: Colors.white, child: Center(child: Image.asset(kLogo))),
          ...list.map((singleItem) {
            return GestureDetector(
              onTap: () async {
                Navigator.pop(context);

                if (singleItem.routeName != null)
                  Navigator.of(context).pushNamed(singleItem.routeName);
                if (singleItem.title == YemString().changeLanguage) {
                  YemenyPrefs prefs = YemenyPrefs();
                  if (context.locale.toString() == 'ar') {
//                    setState(() {
                    context.locale = Locale('en');
                    EasyLocalization.of(context).locale = Locale('en');
                    prefs.setLanguage('en');
                    MainProviderModel mainProviderModel =
                        Provider.of<MainProviderModel>(context, listen: false);
                    mainProviderModel.categories = null;
//                    mainProviderModel.brands = null;
//                    mainProviderModel.modals = null;
                    Navigator.pushNamedAndRemoveUntil(context,
                        HomeController.id, (Route<dynamic> route) => false);
                  } else {
//                    setState(() {
                    context.locale = Locale('ar');
                    EasyLocalization.of(context).locale = Locale('ar');
                    prefs.setLanguage('ar');
                    MainProviderModel mainProviderModel =
                        Provider.of<MainProviderModel>(context, listen: false);
                    mainProviderModel.categories = null;
//                    mainProviderModel.brands = null;
//                    mainProviderModel.modals = null;
                    Navigator.pushNamedAndRemoveUntil(context,
                        HomeController.id, (Route<dynamic> route) => false);
                  }
                }
              },
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(singleItem.title),
                    leading: Icon(
                      singleItem.iconData,
                      color: AppColors().primaryColor(),
                    ),
                  ),
                  Divider(),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class DrawerItem {
  String title;
  String routeName;
  IconData iconData;

  DrawerItem({this.title, this.iconData, this.routeName});
}
