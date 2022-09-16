// To parse this JSON data, do
//
//     final responseProfile = responseProfileFromMap(jsonString);

import 'dart:convert';

ResponseProfile responseProfileFromMap(String str) => ResponseProfile.fromMap(json.decode(str));

String responseProfileToMap(ResponseProfile data) => json.encode(data.toMap());

class ResponseProfile {
  ResponseProfile({
    this.success,
    this.data,
    this.code,
  });

  bool success;
  ProfileData data;
  int code;

  factory ResponseProfile.fromMap(Map<String, dynamic> json) => ResponseProfile(
        success: json["success"],
        data: ProfileData.fromMap(json["data"]),
        code: json["code"],
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "data": data.toMap(),
        "code": code,
      };
}

class ProfileData {
  ProfileData({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.coins,
    this.amount,
    this.image,
    this.userId,
    this.level,
  });

  int id;
  String name;
  String email;
  String phone;
  int coins;
  double amount;
  String image;
  int userId;
  String level;

  factory ProfileData.fromMap(Map<String, dynamic> json) => ProfileData(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        coins: json["coins"],
        amount: json["amount"].toDouble(),
        image: json["image"],
        userId: json["user_id"],
        level: json["level"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "coins": coins,
        "amount": amount,
        "image": image,
        "user_id": userId,
        "level": level,
      };
}
