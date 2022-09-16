import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:kokylive/helper/apis.dart';
import 'package:kokylive/helper/echo.dart';
import 'package:kokylive/helper/shared_pref.dart';
import 'package:kokylive/models/main_provider_model.dart';
import 'package:kokylive/network_models/response_main_data.dart';
import 'package:kokylive/network_models/response_profile.dart';
import 'package:kokylive/network_models/response_status.dart';
import 'package:kokylive/network_models/response_stickers.dart';
import 'package:provider/provider.dart';

Future<MainProviderModel> networkMainData(BuildContext context) async {
  MainProviderModel mainProviderModel = Provider.of<MainProviderModel>(context, listen: false);
//  if (mainProviderModel.categories != null && mainProviderModel.categories.length > 0) {
//    return mainProviderModel;
//  }

//  List<Category> list = new List();

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
//  queryParameters['type'] = registerModel.userType;

  try {
    response = await dio.post(kActiveRoomsApi).whenComplete(() {});
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

  if (token != null) {
    Response response2;
    Dio dio2 = Dio();
    dio2.interceptors.add(LogInterceptor(responseBody: true));
    dio2.options.headers['content-Type'] = 'application/json';
    dio2.options.headers['Content-Language'] = lang;
    dio2.options.headers["authorization"] = "Bearer $token";

//  Map<String, dynamic> queryParameters = Map();
//  queryParameters['type'] = registerModel.userType;


    //get profile data and save
    try {
      response2 = await dio2.post(kProfileApi).whenComplete(() {});
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
      final basicResponse = JsonBasicResponse.fromJson(response2.data);
      if (basicResponse.code == 200) {
        ResponseProfile profileResponse = ResponseProfile.fromMap(response2.data);
        mainProviderModel.profileData = profileResponse.data;
      } else {
        return Future.error(basicResponse.message);
      }
    } catch (e) {
      Echo(e.toString());
      return Future.error('json');
    }
  }

  if (token != null) {
    Response response3;
    Dio dio3 = Dio();
    dio3.interceptors.add(LogInterceptor(responseBody: true));
    dio3.options.headers['content-Type'] = 'application/json';
    dio3.options.headers['Content-Language'] = lang;
    dio3.options.headers["authorization"] = "Bearer $token";

//  Map<String, dynamic> queryParameters = Map();
//  queryParameters['type'] = registerModel.userType;


    //get profile data and save
    try {
      response3 = await dio3.post(kStickersApi).whenComplete(() {});
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
      final basicResponse = JsonBasicResponse.fromJson(response3.data);
      if (basicResponse.code == 200) {
        ResponseStickers stickerResponse = ResponseStickers.fromMap(response3.data);
        mainProviderModel.stickers = stickerResponse.data;
      } else {
        return Future.error(basicResponse.message);
      }
    } catch (e) {
      Echo(e.toString());
      return Future.error('json');
    }
  }
  //end profile data and save

  try {
    final basicResponse = JsonBasicResponse.fromJson(response.data);
    if (basicResponse.code == 200) {
      ResponseMainData mainDataResponse = ResponseMainData.fromMap(response.data);
      mainProviderModel.categories = mainDataResponse.data;
      return mainProviderModel;
    } else {
      return Future.error(basicResponse.message);
    }
  } catch (e) {
    Echo(e.toString());
    return Future.error('json');
  }
}
