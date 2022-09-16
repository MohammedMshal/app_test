// To parse this JSON data, do
//
//     final responseBrands = responseBrandsFromMap(jsonString);

import 'dart:convert';

import 'package:kokylive/models/brand_model.dart';

ResponseBrands responseBrandsFromMap(String str) =>
    ResponseBrands.fromMap(json.decode(str));

String responseBrandsToMap(ResponseBrands data) => json.encode(data.toMap());

class ResponseBrands {
  ResponseBrands({
    this.data,
    this.message,
    this.code,
  });

  List<Brand> data;
  String message;
  int code;

  factory ResponseBrands.fromMap(Map<String, dynamic> json) => ResponseBrands(
        data: List<Brand>.from(json["data"].map((x) => Brand.fromMap(x))),
        message: json["message"],
        code: json["code"],
      );

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
        "message": message,
        "code": code,
      };
}
