// To parse this JSON data, do
//
//     final responseMembershipStickers = responseMembershipStickersFromMap(jsonString);

import 'dart:convert';

ResponseMembershipStickers responseMembershipStickersFromMap(String str) => ResponseMembershipStickers.fromMap(json.decode(str));

String responseMembershipStickersToMap(ResponseMembershipStickers data) => json.encode(data.toMap());

class ResponseMembershipStickers {
  ResponseMembershipStickers({
    this.data,
    this.success,
    this.code,
  });

  List<MembershipSticker> data;
  bool success;
  int code;

  factory ResponseMembershipStickers.fromMap(Map<String, dynamic> json) => ResponseMembershipStickers(
    data: List<MembershipSticker>.from(json["data"].map((x) => MembershipSticker.fromMap(x))),
    success: json["success"],
    code: json["code"],
  );

  Map<String, dynamic> toMap() => {
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
    "success": success,
    "code": code,
  };
}

class MembershipSticker {
  MembershipSticker({
    this.id,
    this.title,
    this.cost,
    this.days,
    this.image,
  });

  int id;
  String title;
  int cost;
  int days;
  String image;

  factory MembershipSticker.fromMap(Map<String, dynamic> json) => MembershipSticker(
    id: json["id"],
    title: json["title"],
    cost: json["cost"],
    days: json["days"],
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "cost": cost,
    "days": days,
    "image": image,
  };
}
