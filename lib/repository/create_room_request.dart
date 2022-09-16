import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:kokylive/helper/apis.dart';
import 'package:kokylive/helper/echo.dart';
import 'package:kokylive/helper/shared_pref.dart';
import 'package:kokylive/models/main_provider_model.dart';
import 'package:kokylive/network_models/response_create_room.dart';
import 'package:kokylive/network_models/response_main_data.dart';
import 'package:kokylive/network_models/response_status.dart';
import 'package:provider/provider.dart';

Future<String> networkCreateRoom(String roomName,BuildContext context) async {
  MainProviderModel mainProviderModel = Provider.of<MainProviderModel>(context, listen: false);
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

  Map<String, dynamic> queryParameters = Map();
  queryParameters['name'] = roomName;
  try {
    response = await dio.post(kCreateRoom, queryParameters: queryParameters).whenComplete(() {});
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
      ResponseCreateRoom createRoomResponse = ResponseCreateRoom.fromMap(response.data);
      mainProviderModel.categories.add(Category(
          id: createRoomResponse.data.id,
          image:createRoomResponse.data.image ,
          name: createRoomResponse.data.name,
          userName:createRoomResponse.data.name ));
      return '${createRoomResponse.data.id}';
    } else {
      return Future.error(basicResponse.message);
    }
  } catch (e) {
    return Future.error('json');
  }
}
