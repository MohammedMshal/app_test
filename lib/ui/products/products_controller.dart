import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kokylive/elements/CircularLoadingWidget.dart';
import 'package:kokylive/elements/no_internet_conn.dart';
import 'package:kokylive/elements/server_error.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/shared_pref.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/models/brand_model.dart';
import 'package:kokylive/models/main_provider_model.dart';
import 'package:kokylive/models/modal_model.dart';
import 'package:kokylive/models/products_provider_model.dart';
import 'package:kokylive/models/route_argument.dart';
import 'package:kokylive/network_models/response_products.dart';
import 'package:kokylive/repository/products_request.dart';
import 'package:kokylive/ui/products/products_view_vertical.dart';
import 'package:kokylive/ui/search/brands_dropdown.dart';
import 'package:kokylive/ui/search/modals_dropdown.dart';
import 'package:provider/provider.dart';

import 'products_view_grid.dart';

class ProductsController extends StatefulWidget {
  static const String id = '/products';
  final RouteArgument args;

  ProductsController({this.args});

  @override
  _ProductsControllerState createState() => _ProductsControllerState();
}

class _ProductsControllerState extends State<ProductsController> {
  List<Brand> brandsList = [];
  List<Modal> modalList = [];
  double priceLow = 0;
  double priceHigh = 50;

  double selectedPriceLow = 0;
  double selectedPriceHigh;

  String selectedBrandId;
  String selectedModalId;

  String filterModalId;
  String filterModalName;
  String filterBrandId;
  String filterBrandName;
  double filterPriceLow = 0;
  double filterPriceHigh = 5000;

  RangeValues rangeValues = new RangeValues(0, 5000);

  @override
  Widget build(BuildContext context) {
    MainProviderModel mainProviderModel =
        Provider.of<MainProviderModel>(context, listen: false);
//    brandsList = mainProviderModel.brands;
//    modalList = mainProviderModel.modals;

    String categoryId = widget.args.id;
    String categoryTitle = widget.args.param;

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors().primaryColor(),
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              centerTitle: true,
              title: Text(
                categoryTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    filterBottomSheet();
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    margin: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    child: Icon(
                      Icons.filter_list,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            body: Container(
              child: FutureBuilder<ProductsProviderModel>(
//      key: GlobalKey(),
                future: networkProducts(context, categoryId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Product> products = snapshot.data.products;

                    //set higher and lower price for filter
                    products.map((singleProduct) {
                      priceHigh =
                          double.parse('${singleProduct.price}') > priceHigh
                              ? double.parse('${singleProduct.price}')
                              : priceHigh;
                    }).toList();
                    if (selectedPriceHigh == null)
                      selectedPriceHigh = priceHigh;
                    //get brand name for brandFilterId
                    if (filterBrandId != null) {
                      filterBrandName = brandsList
                          .where((element) {
                            return '${element.id}' == filterBrandId;
                          })
                          .first
                          .title;
                    }
                    if (filterBrandName != null) {
                      products = products.where((element) {
                        return element.brand == filterBrandName;
                      }).toList();
                    }

                    //get modal name for modalFilterId
                    if (filterModalId != null) {
                      filterModalName = modalList
                          .where((element) {
                            return '${element.id}' == filterModalId;
                          })
                          .first
                          .title;
                    }
                    if (filterModalName != null) {
                      products = products.where((element) {
                        return element.modal == filterModalName;
                      }).toList();
                    }

                    // filter for price range
                    if (filterPriceLow != null) {
                      products = products.where((element) {
                        return element.price >= filterPriceLow;
                      }).toList();
                    }

                    if (filterPriceHigh != null) {
                      products = products.where((element) {
                        return element.price <= filterPriceHigh;
                      }).toList();
                    }

                    return Column(
                      children: [
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${YemString().result} ${products.length}',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        YemenyPrefs prefs = YemenyPrefs();
                                        bool showGridView =
                                            await prefs.getShowGridView();
                                        if (showGridView == true) {
                                          await prefs.setShowGridView(false);
                                          setState(() {
                                            snapshot.data.showGridView = false;
                                          });
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 8),
                                        child: Icon(
                                          Icons.list,
                                          color: snapshot.data.showGridView
                                              ? Colors.grey
                                              : AppColors().primaryColor(),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        YemenyPrefs prefs = YemenyPrefs();
                                        bool showGridView =
                                            await prefs.getShowGridView();
                                        if (showGridView == false) {
                                          await prefs.setShowGridView(true);
                                          setState(() {
                                            snapshot.data.showGridView = true;
                                          });
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 8),
                                        child: Icon(
                                          Icons.border_all,
                                          color: snapshot.data.showGridView
                                              ? AppColors().primaryColor()
                                              : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )),
                        if (!snapshot.data.showGridView)
                          Expanded(
                            flex: 1,
                            child: ProductsViewVertical(
                              list: products,
                            ),
                          ),
                        if (snapshot.data.showGridView)
                          Expanded(
                            flex: 1,
                            child: ProductsViewGrid(
                              list: products,
                            ),
                          ),
                      ],
                    );
                  }
                  if (snapshot.hasError) {
                    if (snapshot.error == null) {
                      return ServerErrorWidget(refresh: () {
                        setState(() {});
                      });
                    }
                    if (snapshot.error == 'network') {
                      return NoInternetConnection(refresh: () {
                        setState(() {});
                      });
                    }
                    if (snapshot.error == 'json') {
                      return ServerErrorWidget(refresh: () {
                        setState(() {});
                      });
                    }
                    return Text(' ${snapshot.error.toString()}');
                  } else
//                    return VerticalProductsShimmer();
                    return CircularLoadingWidget();
                },
              ),
            )));
  }

  filterBottomSheet() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            margin: EdgeInsets.all(16),
            height: 320,
            decoration: new BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                BrandsDropDown(
                  value: selectedBrandId,
                  items: brandsList,
                  validateFunction: (String selectedId) {
                    return null;
                  },
                  updateFunction: (String selectedId) {
                    setState(() {
                      selectedBrandId = selectedId;
                      selectedModalId = null;
                    });
                  },
                ),
                SizedBox(height: 8),
                ModalsDropDown(
                  value: selectedModalId,
                  items: modalList,
                  validateFunction: (String selectedId) {
                    return null;
                  },
                  updateFunction: (String selectedId) {
                    setState(() {
                      selectedModalId = selectedId;
                    });
                  },
                ),
                SizedBox(height: 8),
                Center(child: Text(YemString().price)),
                StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('$selectedPriceLow ${YemString().currency}'),
                              Text(
                                  '$selectedPriceHigh ${YemString().currency}'),
                            ],
                          ),
                        ),
                        RangeSlider(
                          min: priceLow,
                          max: priceHigh,

//                      labels: RangeLabels('selectedPriceLow', 'selectedPriceHigh'),
                          divisions: 100,
                          activeColor: Colors.orange,
                          inactiveColor: Colors.grey,
                          values:
                              RangeValues(selectedPriceLow, selectedPriceHigh),
                          onChanged: (values) => setState(() {
                            var f = NumberFormat('###.0');
                            selectedPriceLow =
                                double.parse(f.format(values.start));
                            selectedPriceHigh =
                                double.parse(f.format(values.end));
                          }),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  // ignore: deprecated_member_use
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        filterBrandId = selectedBrandId;
                        filterModalId = selectedModalId;
                        filterPriceLow = selectedPriceLow;
                        filterPriceHigh = selectedPriceHigh;
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      YemString().filter,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
