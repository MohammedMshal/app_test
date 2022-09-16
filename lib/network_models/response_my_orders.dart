// To parse this JSON data, do
//
//     final responseMyOrders = responseMyOrdersFromMap(jsonString);

import 'dart:convert';

ResponseMyOrders responseMyOrdersFromMap(String str) => ResponseMyOrders.fromMap(json.decode(str));

String responseMyOrdersToMap(ResponseMyOrders data) => json.encode(data.toMap());

class ResponseMyOrders {
  ResponseMyOrders({
    this.data,
    this.success,
    this.code,
  });

  List<SingleOrder> data;
  bool success;
  int code;

  factory ResponseMyOrders.fromMap(Map<String, dynamic> json) => ResponseMyOrders(
    data: List<SingleOrder>.from(json["data"].map((x) => SingleOrder.fromMap(x))),
    success: json["success"],
    code: json["code"],
  );

  Map<String, dynamic> toMap() => {
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
    "success": success,
    "code": code,
  };
}

class SingleOrder {
  SingleOrder({
    this.id,
    this.date,
    this.package,
    this.status,
    this.coins,
    this.cost,
  });

  int id;
  DateTime date;
  String package;
  String status;
  int coins;
  int cost;

  factory SingleOrder.fromMap(Map<String, dynamic> json) => SingleOrder(
    id: json["id"],
    date: DateTime.parse(json["date"]),
    package: json["package"],
    status: json["status"],
    coins: json["coins"],
    cost: json["cost"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "package": package,
    "status": status,
    "coins": coins,
    "cost": cost,
  };
}
