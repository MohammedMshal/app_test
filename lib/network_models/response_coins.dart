// To parse this JSON data, do
//
//     final responseCoins = responseCoinsFromMap(jsonString);

import 'dart:convert';

ResponseCoins responseCoinsFromMap(String str) => ResponseCoins.fromMap(json.decode(str));

String responseCoinsToMap(ResponseCoins data) => json.encode(data.toMap());

class ResponseCoins {
  ResponseCoins({
    this.data,
    this.success,
    this.code,
  });

  List<Coin> data;
  bool success;
  int code;

  factory ResponseCoins.fromMap(Map<String, dynamic> json) => ResponseCoins(
    data: List<Coin>.from(json["data"].map((x) => Coin.fromMap(x))),
    success: json["success"],
    code: json["code"],
  );

  Map<String, dynamic> toMap() => {
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
    "success": success,
    "code": code,
  };
}

class Coin {
  Coin({
    this.id,
    this.title,
    this.amount,
    this.cost,
  });

  int id;
  String title;
  int amount;
  int cost;

  factory Coin.fromMap(Map<String, dynamic> json) => Coin(
    id: json["id"],
    title: json["title"],
    amount: json["amount"],
    cost: json["cost"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "amount": amount,
    "cost": cost,
  };
}
