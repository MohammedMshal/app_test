// To parse this JSON data, do
//
//     final responseSearch = responseSearchFromMap(jsonString);

import 'dart:convert';

import 'package:kokylive/network_models/response_main_data.dart';

ResponseSearch responseSearchFromMap(String str) => ResponseSearch.fromMap(json.decode(str));

String responseSearchToMap(ResponseSearch data) => json.encode(data.toMap());

class ResponseSearch {
  ResponseSearch({
    this.success,
    this.data,
    this.code,
  });

  bool success;
  List<Category> data;
  int code;

  factory ResponseSearch.fromMap(Map<String, dynamic> json) => ResponseSearch(
    success: json["success"],
    data: List<Category>.from(json["data"].map((x) => Category.fromMap(x))),
    code: json["code"],
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
    "code": code,
  };
}

