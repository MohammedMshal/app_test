// To parse this JSON data, do
//
//     final responseProducts = responseProductsFromMap(jsonString);

import 'dart:convert';

ResponseProducts responseProductsFromMap(String str) => ResponseProducts.fromMap(json.decode(str));

String responseProductsToMap(ResponseProducts data) => json.encode(data.toMap());

class ResponseProducts {
  ResponseProducts({
    this.data,
    this.message,
    this.code,
  });

  List<Product> data;
  String message;
  int code;

  factory ResponseProducts.fromMap(Map<String, dynamic> json) => ResponseProducts(
    data: List<Product>.from(json["data"].map((x) => Product.fromMap(x))),
    message: json["message"],
    code: json["code"],
  );

  Map<String, dynamic> toMap() => {
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
    "message": message,
    "code": code,
  };
}

class Product {
  Product({
    this.id,
    this.productNumber,
    this.title,
    this.price,
    this.priceBeforeDiscount,
    this.quantity,
    this.category,
    this.brand,
    this.modal,
    this.image,
  });

  int id;
  String productNumber;
  String title;
  int quantity;
  int price;
  int priceBeforeDiscount;
  String category;
  String brand;
  String modal;
  String image;

  factory Product.fromMap(Map<String, dynamic> json) => Product(
    id: json["id"],
    productNumber: json["product_number"],
    title: json["title"],
    price: json["price"],
    priceBeforeDiscount: json["price_before_discount"],
    category: json["category"],
    brand: json["brand"],
    modal: json["modal"],
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "product_number": productNumber,
    "title": title,
    "price": price,
    "price_before_discount": priceBeforeDiscount,
    "category": category,
    "brand": brand,
    "modal": modal,
    "image": image,
  };
}
