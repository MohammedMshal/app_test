// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';

class Temp with ChangeNotifier{
  List<String> _shopTypesModel = List();

  List<String> get shopTypesModel => _shopTypesModel;

  set shopTypesModel(List<String> value) {
    _shopTypesModel = value;
    notifyListeners();
  }

}