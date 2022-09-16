// ignore_for_file: deprecated_member_use

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:kokylive/elements/YemSnackBar.dart';
import 'package:kokylive/elements/edit_text.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/echo.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/models/route_argument.dart';
import 'package:kokylive/network_models/response_main_data.dart';
import 'package:kokylive/repository/search_text_request.dart';
import 'package:kokylive/ui/user_profile/user_profile_controller.dart';

class SearchTextController extends StatefulWidget {
  static const String id = '/search_text';

  @override
  _SearchTextControllerState createState() => _SearchTextControllerState();
}

class _SearchTextControllerState extends State<SearchTextController> {
  String searchedText;
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Category> _categoryList = List();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 12),
                EditText(
                  autoValidate: false,
                  validateFunc: (String text) {
                    Echo('updateFunc $text');
                    return text.length > 0 ? null : YemString().required;
                  },
                  type: TextInputType.text,
                  hint: YemString().searchFor,
                  iconData: Icons.search,
                  updateFunc: (String text) {
                    Echo('updateFunc $text');
                    searchedText = text;
                  },
                ),
                SizedBox(height: 8),
                if (!_loading)
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          submitForm();
                        }
                      },
                      child: Text(
                        YemString().search,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                if (_loading)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: CircularProgressIndicator(),
                  ),
                if (_categoryList.length > 0)
                  Expanded(
                    flex: 4,
                    child: GridView.count(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 0,
                        childAspectRatio: 0.9,
                        crossAxisCount: 2,
                        primary: false,
                        scrollDirection: Axis.vertical,
                        children: List.generate(
                          _categoryList.length,
                          (index) => SingleView(
                            categoryData: _categoryList[index],
                          ),
                        )),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitForm() async {
    setState(() {
      _categoryList.clear();
    });
    try {
      setState(() {
        _loading = true;
      });
      var response = await networkSearchText(searchedText, '');
      if (response != null) {
        if (response.length > 1) {
          setState(() {
            _categoryList = response;
          });
        } else
          YemSnackBar().showSnackBarMessage(text: YemString().emptySearch, scaffoldKey: _scaffoldKey);
      }

      setState(() {
        _loading = false;
      });
    } catch (e) {
      Echo('5');
      String displayMessage = '';

      setState(() {
        _loading = false;
      });
      if (e.toString() == "network") {
        displayMessage = YemString().noInternetConnection;
      } else if (e.toString() == "json") {
        displayMessage = YemString().errorServerConnection;
      } else {
        displayMessage = e.toString();
      }

      Flushbar(
        backgroundColor: Colors.red,
        title: '',
        message: displayMessage,
        flushbarPosition: FlushbarPosition.TOP,
        duration: Duration(seconds: 2),
      )..show(context);
    }
  }
}

class SingleView extends StatelessWidget {
  final Category categoryData;

  SingleView({this.categoryData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        RouteArgument argument =
            RouteArgument(param: '${categoryData.name}', id: '${categoryData.id}', heroTag: '${categoryData.id}');
        Navigator.of(context).pushNamed(UserProfileController.id, arguments: argument);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        child:
        Text('''kdfnknb''')
        //  Stack(
        //   children: <Widget>[
        //     Positioned(
        //       right: 0,
        //       bottom: 0,
        //       top: 0,
        //       left: 0,
        //       child: CachedNetworkImage(
        //         imageUrl: categoryData.image != null ? categoryData.image : '',
        //         fit: BoxFit.fill,
        //         placeholder: (ctx, url) {
        //           return Center(
        //             child: CircularProgressIndicator(),
        //           );
        //         },
        //       ),
        //     ),
        //     Positioned(
        //         right: 0,
        //         bottom: 0,
        //         top: 0,
        //         left: 0,
        //         child: Container(
        //           decoration: BoxDecoration(
        //               color: Colors.black.withOpacity(0.4), borderRadius: BorderRadius.all(Radius.circular(8))),
        //           width: double.infinity,
        //           height: double.infinity,
        //         )),
        //     Positioned(
        //       right: 0,
        //       bottom: 0,
        //       child: Padding(
        //         padding: const EdgeInsets.all(10.0),
        //         child: Text(
        //           categoryData.name,
        //           textAlign: TextAlign.center,
        //           style: TextStyle(
        //               fontSize: categoryData.name.length > 14 ? 11 : 14,
        //               fontWeight: FontWeight.bold,
        //               color: Colors.white),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
