import 'package:dio/dio.dart';
import 'package:kokylive/helper/apis.dart';
import 'package:kokylive/helper/echo.dart';
import 'package:kokylive/helper/shared_pref.dart';
import 'package:kokylive/models/register_model.dart';
import 'package:kokylive/network_models/response_login.dart';
import 'package:kokylive/network_models/response_status.dart';

Future<String> networkRegister(RegisterModel registerModel) async {
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
  queryParameters['name'] = registerModel.firstName;
  queryParameters['phone'] = registerModel.phone;
  queryParameters['password'] = registerModel.password;
  queryParameters['password_confirmation'] = registerModel.password;
  queryParameters['address'] = registerModel.address;
  queryParameters['email'] = registerModel.email;
  queryParameters['country'] = registerModel.countryId;
  try {
    response = await dio
        .post(kRegisterApi, queryParameters: queryParameters)
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
    final basicResponse = JsonBasicResponse.fromJson(response.data);
    if (basicResponse.success) {
      ResponseLogin registerResponse = ResponseLogin.fromMap(response.data);
      YemenyPrefs prefs = YemenyPrefs();
      prefs.setToken(registerResponse.data.accessToken);
      prefs.setFirstName(registerResponse.data.name);
      prefs.setPhone(registerResponse.data.phone);
      prefs.setUserId(registerResponse.data.id);
      prefs.setEmail(registerResponse.data.email);
      prefs.setEmail(registerResponse.data.email);
      return 'success';
    } else {
      return Future.error(basicResponse.message);
    }
  } catch (e) {
    return Future.error('json');
  }
}
