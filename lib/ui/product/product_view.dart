import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:kokylive/database/cart_database_crud.dart';
import 'package:kokylive/elements/photo_view_zoom.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/models/product_provider_model.dart';
import 'package:kokylive/models/route_argument.dart';

class ProductView extends StatefulWidget {
  final ProductProviderModel productProviderModel;

  ProductView({this.productProviderModel});

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  int selectedImageId;
  CartDatabaseCRUD cartDatabaseCRUD = new CartDatabaseCRUD();
  bool showProductDesc = false;

  @override
  void initState() {
    super.initState();
    if (widget.productProviderModel.images != null &&
        widget.productProviderModel.images.length > 0)
      selectedImageId = widget.productProviderModel.images[0].id;
  }

  @override
  Widget build(BuildContext context) {
//    CartModelProvider cartModelProvider = Provider.of<CartModelProvider>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          if (selectedImageId != null)
            GestureDetector(
              onTap: () {
                RouteArgument args = new RouteArgument();
                args.heroTag = '${widget.productProviderModel.product.brand}';

                args.id =
                    '${widget.productProviderModel.images.where((element) {
                          return element.id == selectedImageId;
                        }).first.id}';

                args.param =
                    '${widget.productProviderModel.images.where((element) {
                          return element.id == selectedImageId;
                        }).first.image}';

                Navigator.pushNamed(context, PhotoViewWidget.id,
                    arguments: args);
              },
              child: CachedNetworkImage(
                imageUrl:
                    '${widget.productProviderModel.images.where((element) {
                          return element.id == selectedImageId;
                        }).first.image}',
                width: double.infinity,
                height: 160,
                fit: BoxFit.fitHeight,
                placeholder: (ctx, url) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          if (widget.productProviderModel.images.length > 1)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...widget.productProviderModel.images.map((singleImage) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedImageId = singleImage.id;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: selectedImageId == singleImage.id
                                      ? Colors.orange
                                      : Colors.grey,
                                  width: 0.2)),
                          child: CachedNetworkImage(
                            imageUrl: singleImage.image,
                            width: 60,
                            height: 60,
                            placeholder: (ctx, url) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
                child: Text(
              widget.productProviderModel.product.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showProductDesc = true;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: showProductDesc
                              ? AppColors().primaryColor()
                              : Colors.grey,
                        ),
                        child: Center(
                          child: Text(
                            YemString().description,
                            style: TextStyle(
                                color: showProductDesc
                                    ? Colors.white
                                    : Colors.black54,
                                fontWeight: showProductDesc
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showProductDesc = false;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: !showProductDesc
                              ? AppColors().primaryColor()
                              : Colors.grey,
                        ),
                        child: Center(
                          child: Text(
                            YemString().details,
                            style: TextStyle(
                                color: !showProductDesc
                                    ? Colors.white
                                    : Colors.black54,
                                fontWeight: !showProductDesc
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showProductDesc) productDesc(),
          if (!showProductDesc) productDetails(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget singleRowText(String title, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                  flex: 5,
                  child: Text(
                    title,
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.start,
                  )),
              Flexible(
                  flex: 8,
                  child: Text(
                    text,
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.end,
                  )),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget productDesc() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: HtmlWidget(widget.productProviderModel.product.description),
    );
  }

  Widget productDetails() {
    return Column(
      children: [
        if (textIsNotReadable(
            widget.productProviderModel.product.productNumber))
          singleRowText(YemString().productNumber,
              widget.productProviderModel.product.productNumber),
        if (textIsNotReadable(widget.productProviderModel.product.category))
          singleRowText(YemString().category,
              widget.productProviderModel.product.category),
        if (textIsNotReadable(widget.productProviderModel.product.brand))
          singleRowText(
              YemString().brand, widget.productProviderModel.product.brand),
        if (textIsNotReadable(widget.productProviderModel.product.modal))
          singleRowText(
              YemString().modal, widget.productProviderModel.product.modal),
        if (textIsNotReadable(widget.productProviderModel.product.location))
          singleRowText(YemString().location,
              widget.productProviderModel.product.location),
        if (textIsNotReadable(
            widget.productProviderModel.product.recommendedUse))
          singleRowText(YemString().recommendedUse,
              widget.productProviderModel.product.recommendedUse),
        if (textIsNotReadable(widget.productProviderModel.product.assembly))
          singleRowText(YemString().assembly,
              widget.productProviderModel.product.assembly),
        if (textIsNotReadable(widget.productProviderModel.product.lightSource))
          singleRowText(YemString().lightSource,
              widget.productProviderModel.product.lightSource),
        if (textIsNotReadable(widget.productProviderModel.product.colorFinish))
          singleRowText(YemString().colorFinish,
              widget.productProviderModel.product.colorFinish),
        if (textIsNotReadable(widget.productProviderModel.product.productFit))
          singleRowText(YemString().productFit,
              widget.productProviderModel.product.productFit),
        if (textIsNotReadable(widget.productProviderModel.product.qualitySold))
          singleRowText(YemString().qualitySold,
              widget.productProviderModel.product.qualitySold),
        if (textIsNotReadable(
            widget.productProviderModel.product.replacesOeNumber))
          singleRowText(YemString().replacesOeNumber,
              widget.productProviderModel.product.replacesOeNumber),
        if (textIsNotReadable(
            widget.productProviderModel.product.replacesPartsNumber))
          singleRowText(YemString().replacesPartsNumber,
              widget.productProviderModel.product.replacesPartsNumber),
        if (textIsNotReadable(widget.productProviderModel.product.warranty))
          singleRowText(YemString().warranty,
              widget.productProviderModel.product.warranty),
        if (textIsNotReadable(
            widget.productProviderModel.product.interchargePartNumber))
          singleRowText(YemString().interChargePartNumber,
              widget.productProviderModel.product.interchargePartNumber),
        if (textIsNotReadable(
            widget.productProviderModel.product.returnsPolicy))
          singleRowText(YemString().returnsPolicy,
              widget.productProviderModel.product.returnsPolicy),
        if (textIsNotReadable(widget.productProviderModel.product.fitNotes))
          singleRowText(YemString().fitNotes,
              widget.productProviderModel.product.fitNotes),
      ],
    );
  }
}

bool textIsNotReadable(String text) {
  if (text == null) return false;
  if (text.isEmpty) return false;
  if (text == '-') return false;
  return true;
}
