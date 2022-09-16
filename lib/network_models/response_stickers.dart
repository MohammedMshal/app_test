// To parse this JSON data, do
//
//     final responseStickers = responseStickersFromMap(jsonString);

import 'dart:convert';

ResponseStickers responseStickersFromMap(String str) => ResponseStickers.fromMap(json.decode(str));

String responseStickersToMap(ResponseStickers data) => json.encode(data.toMap());

class ResponseStickers {
  ResponseStickers({
    this.data,
    this.success,
    this.code,
  });

  List<Sticker> data;
  bool success;
  int code;

  factory ResponseStickers.fromMap(Map<String, dynamic> json) => ResponseStickers(
    data: List<Sticker>.from(json["data"].map((x) => Sticker.fromMap(x))),
    success: json["success"],
    code: json["code"],
  );

  Map<String, dynamic> toMap() => {
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
    "success": success,
    "code": code,
  };
}

class Sticker {
  Sticker({
    this.id,
    this.title,
    this.coins,
    this.image,
  });

  int id;
  String title;
  int coins;
  String image;

  factory Sticker.fromMap(Map<String, dynamic> json) => Sticker(
    id: json["id"],
    title: json["title"],
    coins: json["coins"],
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "coins": coins,
    "image": image,
  };
}
