import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:kokylive/database/cart_database_crud.dart';
import 'package:kokylive/elements/loading_shimmer.dart';
import 'package:kokylive/elements/no_internet_conn.dart';
import 'package:kokylive/elements/server_error.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/models/cart_model_provider.dart';
import 'package:kokylive/models/product_provider_model.dart';
import 'package:kokylive/models/route_argument.dart';
import 'package:kokylive/repository/product_request.dart';
import 'package:kokylive/ui/product/product_view.dart';
import 'package:provider/provider.dart';

class ProductController extends StatefulWidget {
  static const String id = '/product';
  final RouteArgument args;

  ProductController({this.args});

  @override
  _ProductControllerState createState() => _ProductControllerState();
}

class _ProductControllerState extends State<ProductController> {
  CartDatabaseCRUD cartDatabaseCRUD = new CartDatabaseCRUD();

  @override
  Widget build(BuildContext context) {
    CartModelProvider cartModelProvider =
        Provider.of<CartModelProvider>(context);
    String productId = widget.args.id;
    String brand = widget.args.param;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors().primaryColor(),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text(
          brand,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<ProductProviderModel>(
//      key: GlobalKey(),
        future: networkProduct(context, productId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
//                        Container(
//
//                            width: double.infinity,
//                            padding: EdgeInsets.symmetric(horizontal: 12),
//                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                              children: [
//                                Text(
//                                  '${YemString().result} ${snapshot.data.products.length}',
//                                  textAlign: TextAlign.start,
//                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                                ),
//                                Row(
//                                  children: [
////                                    Icon(Icons.list),
////                                    Icon(Icons.grid_on),
//                                  ],
//                                )
//                              ],
//                            )),
                Expanded(
                  flex: 8,
                  child: ProductView(
                    productProviderModel: snapshot.data,
                  ),
                ),

                if (cartModelProvider.cartModel.where((element) {
                      return element.id == snapshot.data.product.id;
                    }).length <
                    1)
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    // ignore: deprecated_member_use
                    child: ElevatedButton(
                      onPressed: () {
                        cartDatabaseCRUD.insert(
                            context: context,
                            id: snapshot.data.product.id,
                            productNumber: snapshot.data.product.productNumber,
                            title: snapshot.data.product.title,
                            price: snapshot.data.product.price,
                            category: snapshot.data.product.category,
                            brand: snapshot.data.product.brand,
                            modal: snapshot.data.product.modal,
                            image: snapshot.data.images != null
                                ? snapshot.data.images.length > 0
                                    ? snapshot.data.images[0].image
                                    : ''
                                : '');

                        Flushbar(
                          backgroundColor: Colors.green,
                          title: '',
                          message: YemString().successAddToCart,
                          flushbarPosition: FlushbarPosition.TOP,
                          duration: Duration(seconds: 2),
                        )..show(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            YemString().addToCart,
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '${snapshot.data.product.price} ${YemString().currency}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (cartModelProvider.cartModel.where((element) {
                      return element.id == snapshot.data.product.id;
                    }).length >
                    0)
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    // ignore: deprecated_member_use
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        YemString().successAddToCart,
                        style: TextStyle(color: Colors.white),
                      ),
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
            return SingleProductShimmer();
        },
      ),
    ));
  }
}
