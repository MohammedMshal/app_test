// To parse this JSON data, do
//
//     final responseLogin = responseLoginFromMap(jsonString);

import 'dart:convert';

ResponseLogin responseLoginFromMap(String str) => ResponseLogin.fromMap(json.decode(str));

String responseLoginToMap(ResponseLogin data) => json.encode(data.toMap());

class ResponseLogin {
  ResponseLogin({
    this.success,
    this.data,
    this.message,
    this.code,
  });

  bool success;
  Data data;
  String message;
  int code;

  factory ResponseLogin.fromMap(Map<String, dynamic> json) => ResponseLogin(
    success: json["success"],
    data: Data.fromMap(json["data"]),
    message: json["message"],
    code: json["code"],
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "data": data.toMap(),
    "message": message,
    "code": code,
  };
}

class Data {
  Data({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.accessToken,
  });

  int id;
  String name;
  String email;
  String phone;
  String accessToken;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    accessToken: json["access_token"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "access_token": accessToken,
  };
}
