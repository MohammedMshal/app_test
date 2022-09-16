// To parse this JSON data, do
//
//     final responseCountries = responseCountriesFromMap(jsonString);

import 'dart:convert';

ResponseCountries responseCountriesFromMap(String str) => ResponseCountries.fromMap(json.decode(str));

String responseCountriesToMap(ResponseCountries data) => json.encode(data.toMap());

class ResponseCountries {
  ResponseCountries({
    this.data,
    this.success,
    this.code,
  });

  List<Country> data;
  bool success;
  int code;

  factory ResponseCountries.fromMap(Map<String, dynamic> json) => ResponseCountries(
    data: List<Country>.from(json["data"].map((x) => Country.fromMap(x))),
    success: json["success"],
    code: json["code"],
  );

  Map<String, dynamic> toMap() => {
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
    "success": success,
    "code": code,
  };
}

class Country {
  Country({
    this.id,
    this.name,
    this.flag,
  });

  int id;
  String name;
  String flag;

  factory Country.fromMap(Map<String, dynamic> json) => Country(
    id: json["id"],
    name: json["name"],
    flag: json["flag"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "flag": flag,
  };
}
