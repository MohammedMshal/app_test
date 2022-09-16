import 'package:flutter/material.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/network_models/response_products.dart';
import 'package:kokylive/ui/products/products_view_grid.dart';

class HomeProducts extends StatelessWidget {
  final List<Product> products;

  HomeProducts({this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Text(
                YemString().newestProducts,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )),
        ProductsViewGrid(list: products),
      ],
    );
  }
}
