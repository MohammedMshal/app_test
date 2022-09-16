import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:kokylive/helper/apis.dart';
import 'package:kokylive/helper/echo.dart';
import 'package:kokylive/helper/shared_pref.dart';
import 'package:kokylive/models/main_provider_model.dart';
import 'package:kokylive/network_models/response_profile.dart';
import 'package:kokylive/network_models/response_status.dart';
import 'package:provider/provider.dart';

Future<ProfileData> networkGetProfile(BuildContext context) async {
  MainProviderModel mainProviderModel = Provider.of<MainProviderModel>(context, listen: false);

  YemenyPrefs prefs = YemenyPrefs();
  String token = await prefs.getToken();

  if(token == null || token.isEmpty)
    return Future.error('auth');
//  Map<String, dynamic> queryParameters = Map();
//  queryParameters['data'] = data;
  if (token != null) {
    Response response;
    Dio dio = Dio();
    dio.interceptors.add(LogInterceptor(responseBody: true));
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer $token";

//  Map<String, dynamic> queryParameters = Map();
//  queryParameters['type'] = registerModel.userType;

    //get profile data and save
    try {
      response = await dio.post(kProfileApi).whenComplete(() {});
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
        ResponseProfile profileResponse = ResponseProfile.fromMap(response.data);
        mainProviderModel.profileData = profileResponse.data;
        return mainProviderModel.profileData;
      } else {
        return Future.error(basicResponse.message);
      }
    } catch (e) {
      Echo(e.toString());
      return Future.error('json');
    }
  }else{
    return Future.error('json');
  }
}
