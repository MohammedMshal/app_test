import 'package:flutter/foundation.dart';
import 'package:kokylive/network_models/response_products.dart';

class ProductsProviderModel with ChangeNotifier {
  List<Product> _products;
  String _categoryId;
  bool _showGridView;

  String get categoryId => _categoryId;

  set categoryId(String value) {
    _categoryId = value;
    notifyListeners();
  }

  List<Product> get products => _products;

  set products(List<Product> value) {
    _products = value;
    notifyListeners();
  }

  bool get showGridView => _showGridView;

  set showGridView(bool value) {
    _showGridView = value;
    notifyListeners();
  }
}
