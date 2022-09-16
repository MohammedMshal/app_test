import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kokylive/database/cart_database_crud.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/shared_pref.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/models/cart_model_provider.dart';
import 'package:kokylive/network_models/response_products.dart';
import 'package:kokylive/ui/login/login_page.dart';
import 'package:kokylive/ui/payment/payment_controller.dart';
import 'package:provider/provider.dart';

class CartController extends StatefulWidget {
  @override
  _CartControllerState createState() => _CartControllerState();
}

class _CartControllerState extends State<CartController> {
  CartDatabaseCRUD cartDatabaseCRUD = new CartDatabaseCRUD();
  List<Product> listCartModel = [];

  @override
  Widget build(BuildContext context) {
    double totalCartAmount = 0;
    listCartModel.clear();
    var cartModelProvider = Provider.of<CartModelProvider>(context);
    cartModelProvider.cartModel.map((singleCartItem) {
      totalCartAmount += (singleCartItem.price * singleCartItem.quantity);
      listCartModel.add(singleCartItem);
    }).toList();

    return Column(
      children: [
        Expanded(
          flex: 1,
          child: ListView(
            children: [
              ...listCartModel.map((singleProduct) {
                return SingleItemView(
                    item: singleProduct, cartDatabaseCRUD: cartDatabaseCRUD);
              }).toList(),
              SizedBox(height: 8),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 1,
              child: Container(
                child: Text(
                  '${YemString().total} $totalCartAmount ${YemString().currency}',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(width: 8),
            Flexible(
              flex: 1,
              child: Container(
                width: double.infinity,
                // ignore: deprecated_member_use
                child: ElevatedButton(
                  onPressed: () async {
                    YemenyPrefs prefs = YemenyPrefs();
                    String userToken = await prefs.getToken();
                    bool loggedUser = userToken == null ? false : true;

                    if (!loggedUser)
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.TOPSLIDE,
                        dialogType: DialogType.INFO,
                        title: YemString().notification,
                        desc: YemString().requireLoginMessage,
                        btnOkText: YemString().login,
                        btnOkColor: Colors.green,
                        btnOkOnPress: () {
                          Navigator.of(context).pushNamed(LoginController.id);
                        },
                      ).show();

                    if (loggedUser)
                      Navigator.pushNamed(context, PaymentController.id);
                  },
                  child: Text(
                    YemString().continueWord,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 25),
      ],
    );
  }
}

class SingleItemView extends StatelessWidget {
  final Product item;
  final CartDatabaseCRUD cartDatabaseCRUD;

  SingleItemView({this.item, this.cartDatabaseCRUD});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.only(top: 8),
                  child: CachedNetworkImage(
                    imageUrl: item.image != null ? item.image : '',
                    fit: BoxFit.fitWidth,
                    placeholder: (ctx, url) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                flex: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(item.category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12)),
                    Text(item.brand,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12)),
                    Text(item.modal,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12)),
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    cartDatabaseCRUD.update(
                      context: context,
                      productId: item.id,
                      quantity: item.quantity + 1,
                      price: item.price,
                    );
                  },
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.add_circle,
                      color: AppColors().primaryColor(),
                      size: 35,
                    ),
                  )),
                ),
              ),
              Flexible(
                flex: 1,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${item.quantity}'),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    if (item.quantity == 1) {
                      cartDatabaseCRUD.removeProduct(
                          context: context, productId: item.id);
                    } else {
                      cartDatabaseCRUD.update(
                        context: context,
                        productId: item.id,
                        quantity: item.quantity - 1,
                        price: item.price,
                      );
                    }
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.remove_circle,
                        color: AppColors().primaryColor(),
                        size: 35,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors().primaryColor(),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Center(
                    child: Text(
                      '${item.price * item.quantity}${YemString().currency}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
