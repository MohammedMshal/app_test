import 'package:dio/dio.dart';
import 'package:kokylive/helper/apis.dart';
import 'package:kokylive/helper/echo.dart';
import 'package:kokylive/helper/shared_pref.dart';
import 'package:kokylive/models/cart_model_provider.dart';
import 'package:kokylive/network_models/response_status.dart';

Future<bool> networkCheckout(CartModelProvider cartModelProvider) async {
  Echo('networkCheckout');

  YemenyPrefs prefs = YemenyPrefs();
  String token = await prefs.getToken();
  String lang = await prefs.getLanguage();
  lang == null ? lang = 'ar' : lang = lang;
  Echo('networkCheckout');

  Response response;
  Dio dio = Dio();
  dio.interceptors.add(LogInterceptor(responseBody: true));
  dio.options.headers['content-Type'] = 'application/json';
  dio.options.headers['Content-Language'] = lang;
  if (token != null) dio.options.headers["authorization"] = "Bearer $token";
  Echo('networkCheckout');

  Map<String, dynamic> queryParameters = Map();

  for (int i = 0; i < cartModelProvider.cartModel.length; i++) {
    queryParameters['products[$i][product_id]'] =
        cartModelProvider.cartModel[i].id;
    queryParameters['products[$i][qty]'] =
        cartModelProvider.cartModel[i].quantity;
  }

  Echo('networkCheckout');
  try {
    response = await dio
        .post('$kCheckoutApi', queryParameters: queryParameters)
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
    return Future.error('network');
  }

  try {
    JsonBasicResponse basicResponse = JsonBasicResponse.fromJson(response.data);
    if (basicResponse.code == 200) {
      return true;
    } else {
      return Future.error(basicResponse.message);
    }
  } catch (e) {
    return Future.error('json');
  }
}
