import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:kokylive/helper/apis.dart';
import 'package:kokylive/helper/echo.dart';
import 'package:kokylive/helper/shared_pref.dart';
import 'package:kokylive/models/main_provider_model.dart';
import 'package:kokylive/network_models/response_status.dart';
import 'package:provider/provider.dart';

Future<JsonBasicResponse> networkCloseRoom(String roomId, BuildContext context) async {

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
//  queryParameters['name'] = roomName;
  try {
    response = await dio.post('$kCloseRoom/$roomId').whenComplete(() {});
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
      if (context != null) {
        MainProviderModel mainProviderModel = Provider.of<MainProviderModel>(context, listen: false);
        mainProviderModel.categories.removeWhere((element) {
          return '${element.id}' == roomId;
        });
      }
      return basicResponse;
    } else {
      return Future.error(basicResponse.message);
    }
  } catch (e) {
    return Future.error('json');
  }
}
