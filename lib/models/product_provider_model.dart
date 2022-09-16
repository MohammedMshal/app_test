import 'package:flutter/foundation.dart';
import 'package:kokylive/network_models/response_product.dart';

class ProductProviderModel with ChangeNotifier {
  SingleProduct _product;
  List<Image> _images;

  List<Image> get images => _images;

  set images(List<Image> value) {
    _images = value;
    notifyListeners();
  }

  SingleProduct get product => _product;

  set product(SingleProduct value) {
    _product = value;
    notifyListeners();
  }
}
