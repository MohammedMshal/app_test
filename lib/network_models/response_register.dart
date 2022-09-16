// To parse this JSON data, do
//
//     final responseRegister = responseRegisterFromMap(jsonString);

import 'dart:convert';

ResponseRegister responseRegisterFromMap(String str) => ResponseRegister.fromMap(json.decode(str));

String responseRegisterToMap(ResponseRegister data) => json.encode(data.toMap());

class ResponseRegister {
  ResponseRegister({
    this.success,
    this.data,
    this.message,
    this.code,
  });

  bool success;
  Data data;
  String message;
  int code;

  factory ResponseRegister.fromMap(Map<String, dynamic> json) => ResponseRegister(
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
    this.lastName,
    this.email,
    this.phone,
    this.accessToken,
  });

  int id;
  String name;
  String lastName;
  String email;
  String phone;
  String accessToken;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    lastName: json["last_name"],
    email: json["email"],
    phone: json["phone"],
    accessToken: json["access_token"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "last_name": lastName,
    "email": email,
    "phone": phone,
    "access_token": accessToken,
  };
}
