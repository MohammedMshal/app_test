// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:kokylive/elements/YemSnackBar.dart';
import 'package:kokylive/elements/edit_text.dart';
import 'package:kokylive/elements/password_edit_text.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/echo.dart';
import 'package:kokylive/helper/images_path.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/models/register_model.dart';
import 'package:kokylive/network_models/response_cities.dart';
import 'package:kokylive/repository/countries_request.dart';
import 'package:kokylive/repository/register_request.dart';
import 'package:kokylive/ui/home/home_controller.dart';
import 'package:kokylive/ui/login/login_page.dart';
import 'package:kokylive/ui/register/countries_dropdown.dart';

import 'items_model.dart';

class RegisterController extends StatefulWidget {
  static const id = '/register';

  @override
  _RegisterControllerState createState() => _RegisterControllerState();
}

class _RegisterControllerState extends State<RegisterController> {
  List<ItemsModel> countriesList = List();
  bool _loading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  RegisterModel registerModel = RegisterModel();
  bool autoValidate = false;

  @override
  void initState() {
    super.initState();
    getCities();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double deviceHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body:
        Text('''kdfnknb''')
        //  Stack(
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
        //           logoHeroAnim(),
        //           registerFormLayout(context),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
      )
    );
  }

  void submitForm() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      performRegister();
      showLoading(true);
    }
  }

  void navigateForgetPassword() {}

  void navigateSignIn() {
    Navigator.pushNamed(context, LoginController.id);
  }

  void goToHome() {
    Navigator.pushNamedAndRemoveUntil(context, HomeController.id, (Route<dynamic> route) => false);
  }

  String validateEmail(String input) {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(input);
    return emailValid ? null : "wrong email format";
//    return input.length > 6 ? null : YemString().phoneIsTooShort;
  }

  Widget registerFormLayout(BuildContext context) {
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
                      style: TextStyle(color: AppColors().primaryColor(), fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 8),
                  CountriesDropDown(
                    autoValidate: autoValidate,
                    value: registerModel.countryId,
                    items: countriesList,
                    validateFunction: (String cityId) {
                      Echo('validate city $cityId');
                      if (cityId != null && cityId.length < 1)
                        return YemString().required;
                      else
                        return null;
                    },
                    updateFunction: (String countryId) {
                      registerModel.countryId = countryId;
                    },
                  ),
                  SizedBox(height: 8),
                  EditText(
                    autoValidate: autoValidate,
                    validateFunc: (String text) {
                      return text.length > 1 ? null : YemString().required;
                    },
                    type: TextInputType.text,
                    hint: YemString().name,
                    iconData: Icons.person,
                    updateFunc: (String text) {
                      registerModel.firstName = text;
                    },
                  ),
                  SizedBox(height: 8),
                  EditText(
                    autoValidate: autoValidate,
                    validateFunc: (String text) {
                      return text.length > 1 ? null : YemString().required;
                    },
                    type: TextInputType.phone,
                    hint: YemString().phone,
                    iconData: Icons.phone,
                    updateFunc: (String text) {
                      registerModel.phone = text;
                    },
                  ),
                  SizedBox(height: 8),
                  EditText(
                    autoValidate: autoValidate,
                    validateFunc: validateEmail,
                    type: TextInputType.emailAddress,
                    hint: YemString().email,
                    iconData: Icons.email,
                    updateFunc: (String text) {
                      registerModel.email = text;
                    },
                  ),
                  SizedBox(height: 8),
                  EditTextPassword(
                    updatePassword: (String text) {
                      registerModel.password = text;
                    },
                    autoValidate: autoValidate,
                    validateFunc: (String text) {
                      return text.length > 1 ? null : YemString().required;
                    },
                  ),

                  SizedBox(height: 8),
                  SizedBox(height: 8),
                  submitButton(),
                  textViewSignUp(),
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
      child: ElevatedButton(
        child: Text(YemString().forgetPassword),
        onPressed: navigateForgetPassword,
      ),
    );
  }

  Widget submitButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _loading
            ? null
            : () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  submitForm();
                } else {
                  if (!autoValidate)
                    setState(() {
                      autoValidate = true;
                    });
                }
              },
        child: Text(
          YemString().register,
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
              child: Text(YemString().login, style: TextStyle(color: AppColors().primaryColor())),
              onTap: navigateSignIn,
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

  void getCities() async {
    showLoading(true);
    try {
      ResponseCountries apiResponse = await networkGetCountries();
      apiResponse.data.map((e) {
        countriesList.add(ItemsModel(id: e.id, name: e.name, other: e.flag));
      }).toList();
    } catch (error) {
      if (error == 'network') {
        YemSnackBar().showNoInternetConnection(function: getCities, scaffoldKey: _scaffoldKey);
      } else if (error == 'json') {
        YemSnackBar().showServerErrorConnection(function: getCities, scaffoldKey: _scaffoldKey);
      } else {
        YemSnackBar().showSnackBarMessage(text: error, scaffoldKey: _scaffoldKey);
      }
    }
    showLoading(false);
  }

  void showLoading(bool status) {
    setState(() {
      _loading = status;
    });
  }

  void performRegister() async {
    try {
      String status = await networkRegister(registerModel);
      if (status == 'success') goToHome();
    } catch (status) {
      if (status == 'network') {
        YemSnackBar().showNoInternetConnection(scaffoldKey: _scaffoldKey);
      } else if (status == 'json') {
        YemSnackBar().showServerErrorConnection(scaffoldKey: _scaffoldKey);
      } else {
        YemSnackBar().showSnackBarMessage(text: status, scaffoldKey: _scaffoldKey);
      }
      setState(() {
        _loading = false;
      });
    }
  }
}
