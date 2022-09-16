import 'package:dio/dio.dart';
import 'package:kokylive/helper/apis.dart';
import 'package:kokylive/helper/echo.dart';
import 'package:kokylive/helper/shared_pref.dart';
import 'package:kokylive/network_models/response_main_data.dart';
import 'package:kokylive/network_models/response_search.dart';
import 'package:kokylive/network_models/response_status.dart';

Future<List<Category>> networkSearchText(String searchText, String countryId) async {
  YemenyPrefs prefs = YemenyPrefs();
  String token = await prefs.getToken();
  String lang = await prefs.getLanguage();
  lang == null ? lang = 'ar' : lang = lang;

  Response response;
  Dio dio = Dio();
  dio.interceptors.add(LogInterceptor(responseBody: true));
  dio.options.headers['content-Type'] = 'application/json';
  dio.options.headers['Content-Language'] = lang;

  Map<String, dynamic> queryParameters = Map();
  queryParameters['search'] = searchText;
//  queryParameters['country'] = countryId;

  try {
    response = await dio.post(kSearchApi, queryParameters: queryParameters).whenComplete(() {});
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
      ResponseSearch responseProducts = ResponseSearch.fromMap(response.data);
      return responseProducts.data;
    } else {
      return Future.error(basicResponse.message);
    }
  } catch (e) {
    Echo(e.toString());
    return Future.error('json');
  }
}
