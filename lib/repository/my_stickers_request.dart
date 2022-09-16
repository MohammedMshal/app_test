import 'package:dio/dio.dart';
import 'package:kokylive/helper/apis.dart';
import 'package:kokylive/helper/echo.dart';
import 'package:kokylive/helper/shared_pref.dart';
import 'package:kokylive/network_models/response_my_stickers.dart';
import 'package:kokylive/network_models/response_status.dart';

Future<List<Sticker>> networkMySticker() async {
  YemenyPrefs prefs = YemenyPrefs();
  String token = await prefs.getToken();
  String lang = await prefs.getLanguage();
  lang == null ? lang = 'ar' : lang = lang;

  Response response;
  Dio dio = Dio();
  dio.interceptors.add(LogInterceptor(responseBody: true));
//  dio.options.headers['content-Type'] = 'application/json';
  dio.options.headers['Content-Language'] = lang;
  if (token != null) dio.options.headers["authorization"] = "Bearer $token";

//  dio.options.headers["authorization"] = "Bearer $token";

//  Map<String, dynamic> queryParameters = Map();
//  queryParameters['data'] = data;
  try {
    response = await dio.post('$kMyStickerApi').whenComplete(() {});
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
      ResponseMyStickers coinsResponse = ResponseMyStickers.fromMap(response.data);
      return coinsResponse.data;
    } else {
      return Future.error(basicResponse.message);
    }
  } catch (e) {
    return Future.error('json');
  }
}
