// To parse this JSON data, do
//
//     final responseBrandModals = responseBrandModalsFromMap(jsonString);

import 'dart:convert';

import 'package:kokylive/models/brand_model.dart';
import 'package:kokylive/models/modal_model.dart';

ResponseBrandModals responseBrandModalsFromMap(String str) =>
    ResponseBrandModals.fromMap(json.decode(str));

String responseBrandModalsToMap(ResponseBrandModals data) =>
    json.encode(data.toMap());

class ResponseBrandModals {
  ResponseBrandModals({
    this.brand,
    this.data,
    this.message,
    this.code,
  });

  Brand brand;
  List<Modal> data;
  String message;
  int code;

  factory ResponseBrandModals.fromMap(Map<String, dynamic> json) =>
      ResponseBrandModals(
        brand: Brand.fromMap(json["brand"]),
        data: List<Modal>.from(json["data"].map((x) => Modal.fromMap(x))),
        message: json["message"],
        code: json["code"],
      );

  Map<String, dynamic> toMap() => {
        "brand": brand.toMap(),
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
        "message": message,
        "code": code,
      };
}
