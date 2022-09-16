// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:kokylive/models/cart_model_provider.dart';
import 'package:kokylive/network_models/response_products.dart';
import 'package:provider/provider.dart';

import 'database_helper.dart';

class CartDatabaseCRUD {
  final _dbHelper = DatabaseHelper.instance;

  void insert({
    @required BuildContext context,
    @required int id,
    @required String productNumber,
    @required String title,
    @required int price,
    @required String category,
    @required String brand,
    @required String modal,
    @required String image,
  }) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnProductId: id,
      DatabaseHelper.columnProductNumber: productNumber,
      DatabaseHelper.columnTitle: title,
      DatabaseHelper.columnPrice: price,
      DatabaseHelper.columnCategory: category,
      DatabaseHelper.columnBrand: brand,
      DatabaseHelper.columnQuantity: 1,
      DatabaseHelper.columnModal: modal,
      DatabaseHelper.columnImage: image,
    };
    await _dbHelper.insert(row);
    await updateCartProviderList(context);
  }

  Future<List<Product>> query() async {
    List<Product> list = [];
    final allRows = await _dbHelper.queryAllRows();
    allRows.forEach((row) {
      list.add(Product(
        id: row[DatabaseHelper.columnProductId],
        productNumber: row[DatabaseHelper.columnProductNumber],
        title: row[DatabaseHelper.columnTitle],
        price: row[DatabaseHelper.columnPrice],
        category: row[DatabaseHelper.columnCategory],
        brand: row[DatabaseHelper.columnBrand],
        modal: row[DatabaseHelper.columnModal],
        image: row[DatabaseHelper.columnImage],
      ));
    });

    return list;
  }

  Future<List<Product>> select(int productId) async {
    List<Product> list = [];
    final selectedRows = await _dbHelper.select(productId);
//    Echo(text: 'selectedRows');
    selectedRows.forEach((row) {
      list.add(Product(
        id: row[DatabaseHelper.columnProductId],
        productNumber: row[DatabaseHelper.columnProductNumber],
        title: row[DatabaseHelper.columnTitle],
        price: row[DatabaseHelper.columnPrice],
        category: row[DatabaseHelper.columnCategory],
        brand: row[DatabaseHelper.columnBrand],
        modal: row[DatabaseHelper.columnModal],
        image: row[DatabaseHelper.columnImage],
      ));
    });
//    Echo(text: list.length);
    return list;
  }

  void update({
    @required BuildContext context,
    @required int productId,
    @required int quantity,
    @required int price,
  }) async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnProductId: productId,
      DatabaseHelper.columnQuantity: quantity,
      DatabaseHelper.columnPrice: price,
    };
    await _dbHelper.update(row);

    await updateCartProviderList(context);
  }

  void removeProduct(
      {@required BuildContext context, @required int productId}) async {
    await _dbHelper.removeProduct(productId);
    await updateCartProviderList(context);
  }

  updateCartProviderList(BuildContext context) async {
    List<Product> cartModelList = new List<Product>();
    final allRows = await _dbHelper.queryAllRows();
    allRows.forEach((row) {
      cartModelList.add(Product(
        id: row[DatabaseHelper.columnProductId],
        productNumber: row[DatabaseHelper.columnProductNumber],
        title: row[DatabaseHelper.columnTitle],
        price: row[DatabaseHelper.columnPrice],
        category: row[DatabaseHelper.columnCategory],
        brand: row[DatabaseHelper.columnBrand],
        modal: row[DatabaseHelper.columnModal],
        image: row[DatabaseHelper.columnImage],
        quantity: row[DatabaseHelper.columnQuantity],
      ));
    });
    var cartModelProvider =
        Provider.of<CartModelProvider>(context, listen: false);
    cartModelProvider.cartModel = cartModelList;
  }

  void delete({@required BuildContext context}) async {
    // Delete all cart products
    await _dbHelper.delete(0);
    updateCartProviderList(context);
  }
}
