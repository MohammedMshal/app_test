import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:kokylive/elements/CircularLoadingWidget.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/images_path.dart';
import 'package:kokylive/helper/strings.dart';

class AboutController extends StatefulWidget {
  static const String id = '/about';

  @override
  _AboutPolicyControllerState createState() => _AboutPolicyControllerState();
}

class _AboutPolicyControllerState extends State<AboutController> {
  @override
  Widget build(BuildContext context) {
    String lang = context.locale.toString();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            title: Text(
              YemString().about,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: AppColors().primaryColor(),
            centerTitle: true),
        body: FutureBuilder<String>(
          future: networkAboutData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(kLogo),
                      Text(snapshot.data),
                    ],
                  ),
                ),
              );
            } else {
              return CircularLoadingWidget();
            }
          },
        ),
      ),
    );
  }

  Future<String> networkAboutData() async {
    return await "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق.";
  }
}
