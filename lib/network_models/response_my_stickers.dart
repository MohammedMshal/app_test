// To parse this JSON data, do
//
//     final responseMyStickers = responseMyStickersFromMap(jsonString);

import 'dart:convert';

ResponseMyStickers responseMyStickersFromMap(String str) => ResponseMyStickers.fromMap(json.decode(str));

String responseMyStickersToMap(ResponseMyStickers data) => json.encode(data.toMap());

class ResponseMyStickers {
  ResponseMyStickers({
    this.data,
    this.success,
    this.code,
  });

  List<Sticker> data;
  bool success;
  int code;

  factory ResponseMyStickers.fromMap(Map<String, dynamic> json) => ResponseMyStickers(
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
    this.cost,
    this.days,
    this.expirationDate,
    this.image,
  });

  int id;
  String title;
  int cost;
  int days;
  DateTime expirationDate;
  String image;

  factory Sticker.fromMap(Map<String, dynamic> json) => Sticker(
    id: json["id"],
    title: json["title"],
    cost: json["cost"],
    days: json["days"],
    expirationDate: DateTime.parse(json["expiration_date"]),
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "cost": cost,
    "days": days,
    "expiration_date": "${expirationDate.year.toString().padLeft(4, '0')}-${expirationDate.month.toString().padLeft(2, '0')}-${expirationDate.day.toString().padLeft(2, '0')}",
    "image": image,
  };
}
