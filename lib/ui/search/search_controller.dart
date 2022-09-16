// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/images_path.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/models/brand_model.dart';
import 'package:kokylive/models/main_provider_model.dart';
import 'package:kokylive/models/modal_model.dart';
import 'package:kokylive/network_models/response_main_data.dart';
import 'package:kokylive/repository/search_request.dart';
import 'package:kokylive/ui/search/categories_dropdown.dart';
import 'package:kokylive/ui/search/factory_year_dropdown.dart';
import 'package:kokylive/ui/search/modals_dropdown.dart';
import 'package:kokylive/ui/search/search_result.dart';
import 'package:provider/provider.dart';

import 'brands_dropdown.dart';

class SearchController extends StatefulWidget {
  static const String id = '/search';

  @override
  _SearchControllerState createState() => _SearchControllerState();
}

class _SearchControllerState extends State<SearchController> {
  String brandId, categoryId, modalId, factoryYear;
  bool _loading = false;
  List<Brand> brandsList = [];
  List<Category> categoriesList = List();
  List<Modal> modalsList = List();
  List<String> factoryYearList = List();

  @override
  Widget build(BuildContext context) {
    if (factoryYearList.length < 1) {
      factoryYearList.add(DateTime.now().year.toString());
      for (int i = 1; i < 22; i++) {
        factoryYearList
            .add(DateTime.now().add(Duration(days: -356 * i)).year.toString());
      }
    }

    MainProviderModel mainProviderModel =
        Provider.of<MainProviderModel>(context, listen: false);
    if (mainProviderModel.categories != null) {
//      categoriesList = mainProviderModel.categories;
//      brandsList = mainProviderModel.brands;
//      modalsList = brandId == null
//          ? mainProviderModel.modals
//          : mainProviderModel.modals.where((element) {
//              return element.brand == int.parse(brandId);
//            }).toList();
    }
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          SizedBox(height: 12),
          Container(
              color: Colors.white,
              child: Center(
                  child: Image.asset(
                    kLogo,
                height: 150,
              ))),
          SizedBox(height: 16),
          CategoriesDropDown(
            value: categoryId,
            items: categoriesList,
            validateFunction: (String selectedId) {
              if (selectedId != null && selectedId.length < 1)
                return YemString().required;
              else
                return null;
            },
            updateFunction: (String selectedId) {
              setState(() {
                categoryId = selectedId;
              });
            },
          ),
          SizedBox(height: 8),
          BrandsDropDown(
            value: brandId,
            items: brandsList,
            validateFunction: (String selectedId) {
              if (selectedId != null && selectedId.length < 1)
                return YemString().required;
              else
                return null;
            },
            updateFunction: (String selectedId) {
              setState(() {
                brandId = selectedId;
                modalId = null;
              });
            },
          ),
          SizedBox(height: 8),
          ModalsDropDown(
            value: modalId,
            items: modalsList,
            validateFunction: (String selectedId) {
              if (selectedId != null && selectedId.length < 1)
                return YemString().required;
              else
                return null;
            },
            updateFunction: (String selectedId) {
              setState(() {
                modalId = selectedId;
              });
            },
          ),
          SizedBox(height: 8),
          FactoryYearDropDown(
            value: factoryYear,
            items: factoryYearList,
            validateFunction: (String selectedId) {
              if (selectedId != null && selectedId.length < 1)
                return YemString().required;
              else
                return null;
            },
            updateFunction: (String selectedId) {
              setState(() {
                factoryYear = selectedId;
              });
            },
          ),
          SizedBox(height: 8),
          if (!_loading)
            Container(
              width: double.infinity,
              // ignore: deprecated_member_use
              child: ElevatedButton(
                onPressed: () async {
                  if (brandId == null &&
                      categoryId == null &&
                      modalId == null) {
                    return false;
                  } else {
                    try {
                      setState(() {
                        _loading = true;
                      });
                      var response = await networkSearch(
                          context, categoryId, brandId, modalId, factoryYear);
                      if (response != null) {
                        Navigator.of(context).pushNamed(SearchResult.id);
                      }

                      setState(() {
                        _loading = false;
                      });
                    } catch (e) {
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
        ],
      ),
    );
  }
}
