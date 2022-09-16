
import 'package:flutter/material.dart';
import 'package:kokylive/database/cart_database_crud.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/models/cart_model_provider.dart';
import 'package:kokylive/models/route_argument.dart';
import 'package:kokylive/network_models/response_products.dart';
import 'package:kokylive/ui/product/product_controller.dart';
import 'package:provider/provider.dart';

class ProductsViewGrid extends StatelessWidget {
  final List<Product> list;

  ProductsViewGrid({this.list});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 0,
        childAspectRatio: 0.77,
        crossAxisCount: 2,
      ),
      itemCount: list.length,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
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
  int imageFlex = 5;
  int contentFlex = 5;
  int footerFlex = 2;
  int footerFlexForOffer = 3;
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
        margin: EdgeInsets.all(4),
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: imageFlex,
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Text('itntiniknrovpn')
                  // Stack(
                  //   children: [
                  //     Center(
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(top: 8),
                  //         child: CachedNetworkImage(
                  //           imageUrl: widget.item.image != null
                  //               ? widget.item.image
                  //               : '',
                  //           fit: BoxFit.fitHeight,
                  //           placeholder: (ctx, url) {
                  //             return Center(
                  //               child: CircularProgressIndicator(),
                  //             );
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //     Positioned(
                  //       top: 0,
                  //       left: 0,
                  //       child: Center(
                  //           child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Icon(
                  //           Icons.favorite,
                  //           color: Colors.grey,
                  //         ),
                  //       )),
                  //     )
                  //   ],
                  // ),
                  ),
            ),
            Flexible(
              flex: contentFlex,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
//                    Text(widget.item.category,
//                        maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11)),
//                    Text(widget.item.brand, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11)),
                    Text('${widget.item.modal}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11)),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: widget.item.priceBeforeDiscount > 0
                  ? footerFlexForOffer
                  : footerFlex,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (cartModelProvider.cartModel.where((element) {
                        return element.id == widget.item.id;
                      }).length <
                      1)
                    Flexible(
                      flex: 5,
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
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors().primaryColor(),
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(8)),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.add_shopping_cart,
                                color: Colors.white,
                              ),
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
                      flex: 5,
                      child: GestureDetector(
                        onTap: () {
                          cartDatabaseCRUD.removeProduct(
                            context: context,
                            productId: widget.item.id,
                          );
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors().primaryColor(),
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(8)),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Flexible(
                    flex: 5,
                    child: Container(
                      width: double.infinity,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.item.priceBeforeDiscount > 0)
                              Text(
                                '${widget.item.price}${YemString().currency}',
                                style: TextStyle(
                                    fontSize: 10,
                                    decoration: TextDecoration.lineThrough),
                              ),
                            Text(
                              '${widget.item.price}${YemString().currency}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors().primaryColor()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
