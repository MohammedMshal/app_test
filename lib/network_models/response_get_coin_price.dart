// To parse this JSON data, do
//
//     final responseGetCoinPrice = responseGetCoinPriceFromMap(jsonString);

import 'dart:convert';

ResponseGetCoinPrice responseGetCoinPriceFromMap(String str) => ResponseGetCoinPrice.fromMap(json.decode(str));

String responseGetCoinPriceToMap(ResponseGetCoinPrice data) => json.encode(data.toMap());

class ResponseGetCoinPrice {
  ResponseGetCoinPrice({
    this.data,
    this.success,
    this.code,
  });

  String data;
  bool success;
  int code;

  factory ResponseGetCoinPrice.fromMap(Map<String, dynamic> json) => ResponseGetCoinPrice(
    data: json["data"],
    success: json["success"],
    code: json["code"],
  );

  Map<String, dynamic> toMap() => {
    "data": data,
    "success": success,
    "code": code,
  };
}
