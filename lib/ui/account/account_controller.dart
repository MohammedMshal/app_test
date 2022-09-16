// ignore_for_file: deprecated_member_use

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/shared_pref.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/models/main_provider_model.dart';
import 'package:kokylive/network_models/response_profile.dart';
import 'package:kokylive/repository/profile_request.dart';
import 'package:kokylive/ui/about_policy/about_controller.dart';
import 'package:kokylive/ui/about_policy/policy_controller.dart';
import 'package:kokylive/ui/coins/coins_controller.dart';
import 'package:kokylive/ui/contact_us/contact_us_controller.dart';
import 'package:kokylive/ui/login/login_page.dart';
import 'package:kokylive/ui/orders/orders_controller.dart';
import 'package:kokylive/ui/profile/profile_screen.dart';
import 'package:kokylive/ui/vip/vipController.dart';
import 'package:kokylive/ui/withdrawals/my_withdrawals_controller.dart';
import 'package:provider/provider.dart';

class AccountController extends StatelessWidget {
  static const id = "account";

  @override
  Widget build(BuildContext context) {
    MainProviderModel mainProviderModel = Provider.of<MainProviderModel>(context, listen: false);
    var list2 = List();
    List<_MoreItemData> list = list2;

    list.add(_MoreItemData(
        title: YemString().shop,
        lead: Icons.store,
        trail: Icons.arrow_forward_ios,
        pageRoute: VipController.id,
        requireAuth: true));

    list.add(_MoreItemData(
        title: YemString().myOrders,
        lead: Icons.reorder,
        trail: Icons.arrow_forward_ios,
        pageRoute: OrdersController.id,
        requireAuth: true));

    list.add(_MoreItemData(
        title: YemString().myWithdrawals,
        lead: Icons.monetization_on,
        trail: Icons.arrow_forward_ios,
        pageRoute: MyWithdrawalsController.id,
        requireAuth: true));

    list.add(_MoreItemData(
        title: YemString().about,
        lead: Icons.info,
        trail: Icons.arrow_forward_ios,
        pageRoute: AboutController.id,
        requireAuth: false));

    list.add(_MoreItemData(
        title: YemString().policyAndTerms,
        lead: Icons.short_text,
        trail: Icons.arrow_forward_ios,
        pageRoute: PolicyController.id,
        requireAuth: false));

    list.add(_MoreItemData(
        title: YemString().contactUs,
        lead: Icons.contact_phone,
        trail: Icons.arrow_forward_ios,
        pageRoute: ContactUs.id,
        requireAuth: false));

    return FutureBuilder<ProfileData>(
        future: networkGetProfile(context),
        builder: (context, snapshot) {
          return Column(
            children: [
              SizedBox(height: 20),
              if (snapshot.data != null && snapshot.data.name.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushNamed(ProfileScreen.id);

                    },
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          child: Container(
                              color: Colors.grey[200],
                              width: 90,
                              height: 90,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data.image == null ? '' : snapshot.data.image,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) {
                                    return Icon(
                                      Icons.perm_identity,
                                      size: 70,
                                    );
                                  },
                                  errorWidget: (context, url, error) {
                                    return Icon(
                                      Icons.perm_identity,
                                      size: 70,
                                    );
                                  },
                                ),
                              )),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data.name,
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            Text(
                             'ID : ${ snapshot.data.userId}',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              snapshot.data.level,
                              style: TextStyle(fontSize: 13, color: AppColors().primaryColor()),
                            ),
//                            Text(YemString().editProfile),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Card(
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: double.infinity,
                            child: Column(
                              children: [
                                SizedBox(height: 6),
                                Image.asset(
                                  'assets/img/ic_star.png',
                                  width: 50,
                                ),
                                SizedBox(height: 6),
                                Text('0 ${YemString().points}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Card(
                        child: GestureDetector(
                          onTap: () async {
                            YemenyPrefs pref = YemenyPrefs();
                            String token = await pref.getToken();
                            if (token != null) {
                              Navigator.of(context).pushNamed(CoinsController.id);
                            } else {
                              AwesomeDialog(
                                context: context,
                                animType: AnimType.TOPSLIDE,
                                dialogType: DialogType.INFO,
                                title: YemString().notification,
                                desc: YemString().requireLoginMessage,
                                btnOkText: YemString().login,
                                btnOkColor: Colors.green,
                                btnOkOnPress: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushNamed(LoginController.id);
                                },
                              ).show();
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            child: Column(
                              children: [
                                SizedBox(height: 6),
                                Image.asset(
                                  'assets/img/ic_coin.png',
                                  width: 50,
                                ),
                                SizedBox(height: 6),
                                if (mainProviderModel.profileData != null &&
                                    mainProviderModel.profileData.coins != null)
                                  Text('${mainProviderModel.profileData.coins} ${YemString().coin}'),
                                if (mainProviderModel.profileData == null ||
                                    mainProviderModel.profileData.coins == null)
                                  Text('0 ${YemString().coin}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ...list.map((singleItem) {
                return GestureDetector(
                  onTap: () async {
                    YemenyPrefs pref = YemenyPrefs();
                    String token  = await pref.getToken();
                    if (singleItem.requireAuth && token == null) {
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.TOPSLIDE,
                        dialogType: DialogType.INFO,
                        title: YemString().notification,
                        desc: YemString().requireLoginMessage,
                        btnOkText: YemString().login,
                        btnOkColor: Colors.green,
                        btnOkOnPress: () {
                          Navigator.of(context).pushNamed(LoginController.id);
                        },
                      ).show();
                    } else {
                      if (singleItem.pageRoute == null) {
                      } else if (singleItem.pageRoute == LoginController.id) {
                        YemenyPrefs pref = YemenyPrefs();
                        pref.logout(context);
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil(singleItem.pageRoute, (Route<dynamic> route) => false);
                      } else
                        Navigator.of(context).pushNamed(singleItem.pageRoute);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey, width: 0.2)),
                    child: ListTile(
                      leading: Icon(singleItem.lead),
                      title: Text(singleItem.title),
                      trailing: Icon(singleItem.trail),
                    ),
                  ),
                );
              }).toList(),
            ],
          );
        });
  }
}

class _MoreItemData {
  String title;
  IconData lead;
  IconData trail;
  String pageRoute;
  bool requireAuth;

  _MoreItemData({
    @required this.title,
    @required this.lead,
    @required this.trail,
    @required this.pageRoute,
    this.requireAuth = false,
  });
}
