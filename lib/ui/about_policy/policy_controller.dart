import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:kokylive/elements/CircularLoadingWidget.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/images_path.dart';
import 'package:kokylive/helper/strings.dart';

class PolicyController extends StatefulWidget {
  static const String id = '/policy';

  @override
  _AboutPolicyControllerState createState() => _AboutPolicyControllerState();
}

class _AboutPolicyControllerState extends State<PolicyController> {
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
              YemString().policyAndTerms,
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
                    children: <Widget>[
                      Image.asset(kLogo),
                      HtmlWidget(snapshot.data),
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
    return "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق.";
  }
}
