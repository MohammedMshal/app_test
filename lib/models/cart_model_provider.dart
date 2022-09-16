// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:kokylive/network_models/response_products.dart';

class CartModelProvider with ChangeNotifier {
  List<Product> _cartModel = List();

  List<Product> get cartModel {
    return _cartModel;
  }

  set cartModel(List<Product> value) {
    _cartModel = value;
    notifyListeners();
  }

  addNewItemToList(Product model) {
    _cartModel.add(model);
    notifyListeners();
  }
}
