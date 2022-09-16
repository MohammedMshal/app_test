import 'package:dio/dio.dart';
import 'package:kokylive/helper/apis.dart';
import 'package:kokylive/helper/echo.dart';
import 'package:kokylive/helper/shared_pref.dart';
import 'package:kokylive/network_models/response_my_orders.dart';
import 'package:kokylive/network_models/response_status.dart';

Future<List<SingleOrder>> networkGetMyOrders() async {
  YemenyPrefs prefs = YemenyPrefs();
  String token = await prefs.getToken();
  String lang = await prefs.getLanguage();
  lang == null ? lang = 'ar' : lang = lang;

  Response dioResponse;
  Dio dio = Dio();
  dio.interceptors.add(LogInterceptor(responseBody: true));
//  dio.options.headers['content-Type'] = 'application/json';
  dio.options.headers['Content-Language'] = lang;
  if (token != null) dio.options.headers["authorization"] = "Bearer $token";

//  Map<String, dynamic> queryParameters = Map();
//  queryParameters['data'] = data;
  try {
    dioResponse = await dio.post('$kOrdersApi').whenComplete(() {});
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
    JsonBasicResponse basicResponse = JsonBasicResponse.fromJson(dioResponse.data);
    if (basicResponse.code == 200) {
      ResponseMyOrders response = ResponseMyOrders.fromMap(dioResponse.data);
      return response.data;
    } else {
      return Future.error(basicResponse.message);
    }
  } catch (e) {
    return Future.error('json');
  }
}
