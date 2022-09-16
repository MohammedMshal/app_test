import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:kokylive/helper/apis.dart';
import 'package:kokylive/helper/echo.dart';
import 'package:kokylive/helper/shared_pref.dart';
import 'package:kokylive/models/products_provider_model.dart';
import 'package:kokylive/network_models/response_products.dart';
import 'package:kokylive/network_models/response_status.dart';
import 'package:provider/provider.dart';

Future<ProductsProviderModel> networkSearch(
    BuildContext context,
    String categoryId,
    String brandId,
    String modalId,
    String factoryYear) async {
  YemenyPrefs prefs = YemenyPrefs();
  bool showGridView = await prefs.getShowGridView();

  ProductsProviderModel productsProviderModel =
      Provider.of<ProductsProviderModel>(context, listen: false);

  String token = await prefs.getToken();
  String lang = await prefs.getLanguage();
  lang == null ? lang = 'ar' : lang = lang;

  Response response;
  Dio dio = Dio();
  dio.interceptors.add(LogInterceptor(responseBody: true));
  dio.options.headers['content-Type'] = 'application/json';
  dio.options.headers['Content-Language'] = lang;

  Map<String, dynamic> queryParameters = Map();
  queryParameters['category'] = categoryId;
  queryParameters['brand'] = brandId;
  queryParameters['modal'] = modalId;
  queryParameters['year'] = factoryYear;

  try {
    response = await dio
        .get(kProductsApi, queryParameters: queryParameters)
        .whenComplete(() {});
  } on DioError catch (e) {
    if (e.response != null) {
      Echo('${e.response.data}');
      Echo('${e.response.headers}');
      Echo('${e.response.request}');
    } else {
      Echo('${e.request}');
      Echo('${e.message}');
    }
    return Future.error("network");
  }

  try {
    final basicResponse = JsonBasicResponse.fromJson(response.data);
    if (basicResponse.code == 200) {
      ResponseProducts responseProducts =
          ResponseProducts.fromMap(response.data);
      productsProviderModel.products = responseProducts.data;
      productsProviderModel.categoryId = null;
      productsProviderModel.showGridView = showGridView;
      return productsProviderModel;
    } else {
      return Future.error(basicResponse.message);
    }
  } catch (e) {
    Echo(e.toString());
    return Future.error('json');
  }
}
