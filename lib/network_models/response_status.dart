// To parse this JSON data, do
//
//     final jsonBasicResponse = jsonBasicResponseFromJson(jsonString);

import 'dart:convert';

JsonBasicResponse jsonBasicResponseFromJson(String str) => JsonBasicResponse.fromJson(json.decode(str));

String jsonBasicResponseToJson(JsonBasicResponse data) => json.encode(data.toJson());

class JsonBasicResponse {
  bool success;
  String message;
  int code;

  JsonBasicResponse({
    this.success,
    this.message,
    this.code,
  });

  factory JsonBasicResponse.fromJson(Map<String, dynamic> json) => JsonBasicResponse(
    success: json["success"],
    message: json["message"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "code": code,
  };
}
