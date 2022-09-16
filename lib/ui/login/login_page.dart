import 'package:flutter/material.dart';
import 'package:kokylive/elements/YemSnackBar.dart';
import 'package:kokylive/elements/edit_text.dart';
import 'package:kokylive/elements/password_edit_text.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/images_path.dart';
import 'package:kokylive/helper/shared_pref.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/repository/login_request.dart';
import 'package:kokylive/ui/home/home_controller.dart';

import '../register/register_controller.dart';

class LoginController extends StatefulWidget {
  static const id = 'login';

  @override
  _LoginControllerState createState() => _LoginControllerState();
}

class _LoginControllerState extends State<LoginController> {
  bool _loading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String inputEmail, inputPassword;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      color: AppColors().primaryDarkColor(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          // body: Stack(
          //   children: <Widget>[
          //     Positioned(
          //       top: 0,
          //       left: 0,
          //       right: 0,
          //       child: Container(
          //         height: deviceHeight / 2,
          //         color: AppColors().accentColor(),
          //       ),
          //     ),
          //     SingleChildScrollView(
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: <Widget>[
          //           SizedBox(height: 50),
          //           logoHeroAnim(),
          //           loginFormLayout(context),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }

  void submitForm(String email, String password) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _loading = true;
      });

      try {
        String status = await networkLogin(email, password);
        if (status == 'success') goToHome();
      } catch (status) {
        if (status == 'network') {
          YemSnackBar().showNoInternetConnection(scaffoldKey: _scaffoldKey);
        } else {
          YemSnackBar()
              .showSnackBarMessage(text: status, scaffoldKey: _scaffoldKey);
        }
      }

      setState(() {
        _loading = false;
      });
    }
  }

  void navigateForgetPassword() {}

  void navigateSignUp() {
    Navigator.pushNamed(context, RegisterController.id);
  }

  void goToHome() {
    Navigator.pushNamedAndRemoveUntil(
        context, HomeController.id, (Route<dynamic> route) => false);
  }

  String validateEmail(String input) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(input);
    return emailValid ? null : YemString().emailInputError;
//    return input.length > 6 ? null : YemString().phoneIsTooShort;
  }

  Widget loginFormLayout(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          elevation: 4,
          color: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 6),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  _loading ? LinearProgressIndicator() : Container(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      YemString().login,
                      style: TextStyle(
                          color: AppColors().primaryColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  EditText(
                    validateFunc: validateEmail,
                    type: TextInputType.emailAddress,
                    hint: YemString().email,
                    iconData: Icons.email,
                    updateFunc: (String text) {
                      inputEmail = text;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  EditTextPassword(
                    updatePassword: (String text) {
                      inputPassword = text;
                    },
                    validateFunc: (String text) {
                      return text.length > 1 ? null : YemString().required;
                    },
                  ),
                  textViewForgetPassword(),
                  submitButton(),
                  textViewSignUp(),
                  textViewSkip(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget textViewForgetPassword() {
    return Container(
      alignment: Alignment.topRight,
      // ignore: deprecated_member_use
      child: ElevatedButton(
        child: Text(YemString().forgetPassword),
        onPressed: navigateForgetPassword,
      ),
    );
  }

  Widget submitButton() {
    return Container(
      width: double.infinity,
      // ignore: deprecated_member_use
      child: ElevatedButton(
        onPressed: _loading
            ? () {}
            : () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  submitForm(inputEmail, inputPassword);
                }
              },
        child: Text(
          YemString().login,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget textViewSignUp() {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(YemString().doNotHaveAnAccount),
          Padding(
            padding: EdgeInsets.all(12),
            child: GestureDetector(
              child: Text(YemString().register,
                  style: TextStyle(color: AppColors().primaryColor())),
              onTap: navigateSignUp,
            ),
          ),
        ],
      ),
    );
  }

  Widget textViewSkip() {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16),
            child: GestureDetector(
              child: Text(YemString().skip,
                  style: TextStyle(color: AppColors().primaryColor())),
              onTap: () async {
                YemenyPrefs pref = YemenyPrefs();
                pref.setSkipAuth(true);

                goToHome();
              },
            ),
          ),
        ],
      ),
    );
  }

  Hero logoHeroAnim() {
    return Hero(
      tag: "logo",
      child: Image.asset(
        kLogo,
        height: 120,
      ),
    );
  }
}
