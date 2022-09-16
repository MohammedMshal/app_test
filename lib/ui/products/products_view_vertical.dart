import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kokylive/database/cart_database_crud.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/models/cart_model_provider.dart';
import 'package:kokylive/models/route_argument.dart';
import 'package:kokylive/network_models/response_products.dart';
import 'package:kokylive/ui/product/product_controller.dart';
import 'package:provider/provider.dart';

class ProductsViewVertical extends StatelessWidget {
  final List<Product> list;

  ProductsViewVertical({this.list});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 0.4,
        childAspectRatio: 2.4,
        crossAxisCount: 1,
      ),
      itemCount: list.length,
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      primary: false,
      itemBuilder: (BuildContext context, int index) {
        return SingleItemView(item: list[index]);
      },
    );
  }
}

class SingleItemView extends StatefulWidget {
  final Product item;

  SingleItemView({this.item});

  @override
  _SingleItemViewState createState() => _SingleItemViewState();
}

class _SingleItemViewState extends State<SingleItemView> {
  CartDatabaseCRUD cartDatabaseCRUD = new CartDatabaseCRUD();

  @override
  Widget build(BuildContext context) {
    CartModelProvider cartModelProvider =
        Provider.of<CartModelProvider>(context);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductController.id,
            arguments: RouteArgument(
                heroTag: 'product',
                id: '${widget.item.id}',
                param: widget.item.brand));
      },
      child: Card(
        elevation: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.only(top: 8),
                      child: CachedNetworkImage(
                        imageUrl:
                            widget.item.image != null ? widget.item.image : '',
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
                          widget.item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(widget.item.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12)),
                        Text(widget.item.brand,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12)),
                        Text(widget.item.modal,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.grey,
                    ),
                  )),
                ),
                if (cartModelProvider.cartModel.where((element) {
                      return element.id == widget.item.id;
                    }).length <
                    1)
                  Flexible(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        cartDatabaseCRUD.insert(
                            context: context,
                            id: widget.item.id,
                            productNumber: widget.item.productNumber,
                            title: widget.item.title,
                            price: widget.item.price,
                            category: widget.item.category,
                            brand: widget.item.brand,
                            modal: widget.item.modal,
                            image:
                                widget.item != null ? widget.item.image : '');
                        setState(() {});
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.add_shopping_cart,
                            color: AppColors().primaryColor(),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (cartModelProvider.cartModel.where((element) {
                      return element.id == widget.item.id;
                    }).length >
                    0)
                  Flexible(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        cartDatabaseCRUD.removeProduct(
                          context: context,
                          productId: widget.item.id,
                        );
                        setState(() {});
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                Flexible(
                  flex: 2,
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors().primaryColor(),
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(8)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.item.price}${YemString().currency}',
                          style: TextStyle(
                              fontSize: 10,
                              decoration: TextDecoration.lineThrough),
                        ),
                        SizedBox(width: 6),
                        Text(
                          '${widget.item.price}${YemString().currency}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
