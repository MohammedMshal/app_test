import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:kokylive/helper/apis.dart';
import 'package:kokylive/helper/echo.dart';
import 'package:kokylive/helper/shared_pref.dart';
import 'package:kokylive/models/product_provider_model.dart';
import 'package:kokylive/network_models/response_product.dart';
import 'package:kokylive/network_models/response_status.dart';
import 'package:provider/provider.dart';

Future<ProductProviderModel> networkProduct(
    BuildContext context, String productId) async {
  ProductProviderModel productProviderModel =
      Provider.of<ProductProviderModel>(context, listen: false);
  if (productProviderModel.product != null &&
      productProviderModel.images != null &&
      '${productProviderModel.product.id}' == productId &&
      productProviderModel.images.length > 0) {
    return productProviderModel;
  }

  YemenyPrefs prefs = YemenyPrefs();
  String token = await prefs.getToken();
  String lang = await prefs.getLanguage();
  lang == null ? lang = 'ar' : lang = lang;

  Response response;
  Dio dio = Dio();
  dio.interceptors.add(LogInterceptor(responseBody: true));
  dio.options.headers['content-Type'] = 'application/json';
  dio.options.headers['Content-Language'] = lang;
  if (token != null) dio.options.headers["authorization"] = "Bearer $token";

//  Map<String, dynamic> queryParameters = Map();
//  queryParameters['category'] = productId;

  try {
    response = await dio.get('$kProductApi/$productId').whenComplete(() {});
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
      ResponseProduct responseProducts = ResponseProduct.fromMap(response.data);
      productProviderModel.product = responseProducts.data;
      productProviderModel.images = responseProducts.images;
      return productProviderModel;
    } else {
      return Future.error(basicResponse.message);
    }
  } catch (e) {
    Echo(e.toString());
    return Future.error('json');
  }
}
