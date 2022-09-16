import 'package:flutter/material.dart';
import 'package:kokylive/elements/CircularLoadingWidget.dart';
import 'package:kokylive/elements/edit_text.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/ui/home/home_controller.dart';

class ContactUs extends StatefulWidget {
  static const id = "/sendContactUs";

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _loading = false;
  bool statusSuccess = false;

  String inputPhone = '';
  String inputEmail = '';
  String inputName = '';
  String inputMessage = '';

  updatePhoneOnFormSave(String text) {
    inputPhone = text;
  }

  updateEmailOnFormSave(String text) {
    inputEmail = text;
  }

  updateNameOnFormSave(String text) {
    inputName = text;
  }

  updateMessageOnFormSave(String text) {
    inputMessage = text;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors().primaryColor(),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          centerTitle: true,
          title: Text(
            YemString().contactUs,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: statusSuccess
            ? Center(
                child: Container(
                  height: height / 1.3,
                  child: Column(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 16),
                          Icon(
                            Icons.check_circle,
                            size: width / 2,
                            color: Colors.green,
                          ),
                          SizedBox(height: 16),
                          Text(YemString().successSendForm,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            // ignore: deprecated_member_use
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed(HomeController.id);
                              },
                              child: Text(
                                YemString().backToHome,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : _loading
                ? CircularLoadingWidget()
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: contactFormLayout(),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget contactFormLayout() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            if (_loading) LinearProgressIndicator(),
            SizedBox(height: 8),
            EditText(
              iconData: Icons.person,
              hint: YemString().name,
              updateFunc: updateNameOnFormSave,
              validateFunc: (input) {
                return input.length < 1 ? YemString().required : null;
              },
            ),
            SizedBox(height: 8),
            EditText(
              iconData: Icons.phone,
              hint: YemString().phoneHint,
              updateFunc: updatePhoneOnFormSave,
              validateFunc: (input) {
                return input.length < 1 ? YemString().required : null;
              },
            ),
            SizedBox(height: 8),
            EditText(
              iconData: Icons.email,
              hint: YemString().email,
              updateFunc: updateEmailOnFormSave,
              validateFunc: (input) {
                return input.length < 1 ? YemString().required : null;
              },
            ),
//            SizedBox(height: 8),
//            PhoneEditText(
//              updatePhone: updatePhoneOnFormSave,
//            ),
            SizedBox(height: 8),
            EditText(
              iconData: Icons.message,
              hint: YemString().message,
              lines: 3,
              updateFunc: updateMessageOnFormSave,
              validateFunc: (input) {
                return input.length < 6 ? YemString().required : null;
              },
            ),
            SizedBox(height: 20),
            submitButton(),
          ],
        ),
      ),
    );
  }

  Widget submitButton() {
    // ignore: deprecated_member_use
    return ElevatedButton(
      onPressed: _loading ? null : submitForm,
      child: Text(
        YemString().send,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      networkSendForm(inputName, inputEmail, inputPhone, inputMessage);
    }
  }

  void networkSendForm(
      String userName, String email, String phone, String content) async {
//setState(() {
//  _loading = true;
//});
//    try {
//      Dio dio = Dio();
//      dio.interceptors.add(LogInterceptor(responseBody: true));
//
//      FormData formData = FormData.fromMap({
//        "username": userName,
//        "email": email,
//        "phone": phone,
//        "content": content,
//      });
//
//      Response response = await dio.post(kSendForm, data: formData).whenComplete(() {});
//      final basicJsonResponse = JsonBasicResponse.fromJson(response.data);
//      if (basicJsonResponse.status == YemString().successNoTranslate) {
//        setState(() {
//          _loading = false;
//          statusSuccess = true;
//        });
//      } else {}
//    } on DioError catch (e) {
//      setState(() {
//        _loading = false;
//        statusSuccess = false;
//      });
//    }
//  }
  }
}
