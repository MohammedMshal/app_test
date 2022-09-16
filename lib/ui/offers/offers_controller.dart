import 'package:flutter/material.dart';
import 'package:kokylive/models/main_provider_model.dart';
import 'package:kokylive/ui/products/products_view_grid.dart';
import 'package:provider/provider.dart';

class OffersController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    MainProviderModel mainProviderModel =
        Provider.of<MainProviderModel>(context, listen: false);
    return ProductsViewGrid(
//      list: mainProviderModel.products,
    );
  }
}
