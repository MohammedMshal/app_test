// To parse this JSON data, do
//
//     final responseMyWithdrawals = responseMyWithdrawalsFromMap(jsonString);

import 'dart:convert';

ResponseMyWithdrawals responseMyWithdrawalsFromMap(String str) => ResponseMyWithdrawals.fromMap(json.decode(str));

String responseMyWithdrawalsToMap(ResponseMyWithdrawals data) => json.encode(data.toMap());

class ResponseMyWithdrawals {
  ResponseMyWithdrawals({
    this.data,
    this.success,
    this.code,
  });

  List<SingleWithdrawal> data;
  bool success;
  int code;

  factory ResponseMyWithdrawals.fromMap(Map<String, dynamic> json) => ResponseMyWithdrawals(
    data: List<SingleWithdrawal>.from(json["data"].map((x) => SingleWithdrawal.fromMap(x))),
    success: json["success"],
    code: json["code"],
  );

  Map<String, dynamic> toMap() => {
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
    "success": success,
    "code": code,
  };
}

class SingleWithdrawal {
  SingleWithdrawal({
    this.id,
    this.date,
    this.status,
    this.coins,
    this.coinPrice,
  });

  int id;
  DateTime date;
  String status;
  int coins;
  double coinPrice;

  factory SingleWithdrawal.fromMap(Map<String, dynamic> json) => SingleWithdrawal(
    id: json["id"],
    date: DateTime.parse(json["date"]),
    status: json["status"],
    coins: json["coins"],
    coinPrice: json["coin_price"].toDouble(),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "status": status,
    "coins": coins,
    "coin_price": coinPrice,
  };
}
