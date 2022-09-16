// To parse this JSON data, do
//
//     final responseUserProfile = responseUserProfileFromJson(jsonString);

import 'dart:convert';

ResponseUserProfile responseUserProfileFromJson(String str) => ResponseUserProfile.fromJson(json.decode(str));

String responseUserProfileToJson(ResponseUserProfile data) => json.encode(data.toJson());

class ResponseUserProfile {
  ResponseUserProfile({
    this.success,
    this.data,
    this.stickers,
    this.code,
  });

  bool success;
  Data data;
  List<Sticker> stickers;
  int code;

  factory ResponseUserProfile.fromJson(Map<String, dynamic> json) => ResponseUserProfile(
    success: json["success"],
    data: Data.fromJson(json["data"]),
    stickers: List<Sticker>.from(json["stickers"].map((x) => Sticker.fromJson(x))),
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
    "stickers": List<dynamic>.from(stickers.map((x) => x.toJson())),
    "code": code,
  };
}

class Data {
  Data({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.coins,
    this.image,
    this.userId,
    this.level,
  });

  int id;
  String name;
  String email;
  String phone;
  int coins;
  String image;
  int userId;
  String level;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    coins: json["coins"],
    image: json["image"],
    userId: json["user_id"],
    level: json["level"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "coins": coins,
    "image": image,
    "user_id": userId,
    "level": level,
  };
}

class Sticker {
  Sticker({
    this.id,
    this.title,
    this.image,
  });

  int id;
  String title;
  String image;

  factory Sticker.fromJson(Map<String, dynamic> json) => Sticker(
    id: json["id"],
    title: json["title"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
  };
}
