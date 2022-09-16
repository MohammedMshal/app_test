// To parse this JSON data, do
//
//     final responseMainData = responseMainDataFromMap(jsonString);

import 'dart:convert';

ResponseMainData responseMainDataFromMap(String str) => ResponseMainData.fromMap(json.decode(str));

String responseMainDataToMap(ResponseMainData data) => json.encode(data.toMap());

class ResponseMainData {
  ResponseMainData({
    this.success,
    this.data,
    this.code,
  });

  bool success;
  List<Category> data;
  int code;

  factory ResponseMainData.fromMap(Map<String, dynamic> json) => ResponseMainData(
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

class Category {
  Category({
    this.id,
    this.name,
    this.userName,
    this.image,
  });

  int id;
  String name;
  String userName;
  String image;

  factory Category.fromMap(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    userName: json["user_name"],
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "user_name": userName,
    "image": image,
  };
}
