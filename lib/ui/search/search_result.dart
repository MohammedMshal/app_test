import 'package:flutter/material.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/shared_pref.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/models/products_provider_model.dart';
import 'package:kokylive/models/route_argument.dart';
import 'package:kokylive/ui/products/products_view_grid.dart';
import 'package:kokylive/ui/products/products_view_vertical.dart';
import 'package:provider/provider.dart';

class SearchResult extends StatefulWidget {
  static const String id = '/search_result';
  final RouteArgument args;

  SearchResult({this.args});

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    ProductsProviderModel providerModel =
        Provider.of<ProductsProviderModel>(context, listen: false);
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors().primaryColor(),
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              centerTitle: true,
              title: Text(
                YemString().search,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            body: Column(
              children: [
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${YemString().result} ${providerModel.products.length}',
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
                                    providerModel.showGridView = false;
                                  });
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                child: Icon(
                                  Icons.list,
                                  color: providerModel.showGridView
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
                                    providerModel.showGridView = true;
                                  });
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                child: Icon(
                                  Icons.border_all,
                                  color: providerModel.showGridView
                                      ? AppColors().primaryColor()
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
                if (!providerModel.showGridView)
                  Expanded(
                    flex: 1,
                    child: ProductsViewVertical(
                      list: providerModel.products,
                    ),
                  ),
                if (providerModel.showGridView)
                  Expanded(
                    flex: 1,
                    child: ProductsViewGrid(
                      list: providerModel.products,
                    ),
                  ),
              ],
            )));
  }
}
