// To parse this JSON data, do
//
//     final responseCreateRoom = responseCreateRoomFromMap(jsonString);

import 'dart:convert';

ResponseCreateRoom responseCreateRoomFromMap(String str) => ResponseCreateRoom.fromMap(json.decode(str));

String responseCreateRoomToMap(ResponseCreateRoom data) => json.encode(data.toMap());

class ResponseCreateRoom {
  ResponseCreateRoom({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  bool success;
  String message;
  Data data;
  int code;

  factory ResponseCreateRoom.fromMap(Map<String, dynamic> json) => ResponseCreateRoom(
    success: json["success"],
    message: json["message"],
    data: Data.fromMap(json["data"]),
    code: json["code"],
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "message": message,
    "data": data.toMap(),
    "code": code,
  };
}

class Data {
  Data({
    this.id,
    this.name,
    this.image,
  });

  int id;
  String name;
  String image;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "image": image,
  };
}
