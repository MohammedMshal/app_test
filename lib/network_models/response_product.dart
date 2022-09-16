// To parse this JSON data, do
//
//     final responseProduct = responseProductFromMap(jsonString);

import 'dart:convert';

ResponseProduct responseProductFromMap(String str) => ResponseProduct.fromMap(json.decode(str));

String responseProductToMap(ResponseProduct data) => json.encode(data.toMap());

class ResponseProduct {
  ResponseProduct({
    this.data,
    this.images,
    this.message,
    this.code,
  });

  SingleProduct data;
  List<Image> images;
  String message;
  int code;

  factory ResponseProduct.fromMap(Map<String, dynamic> json) => ResponseProduct(
    data: SingleProduct.fromMap(json["data"]),
    images: List<Image>.from(json["images"].map((x) => Image.fromMap(x))),
    message: json["message"],
    code: json["code"],
  );

  Map<String, dynamic> toMap() => {
    "data": data.toMap(),
    "images": List<dynamic>.from(images.map((x) => x.toMap())),
    "message": message,
    "code": code,
  };
}

class SingleProduct {
  SingleProduct({
    this.id,
    this.productNumber,
    this.description,
    this.title,
    this.price,
    this.category,
    this.brand,
    this.modal,
    this.location,
    this.recommendedUse,
    this.assembly,
    this.lightSource,
    this.colorFinish,
    this.productFit,
    this.qualitySold,
    this.replacesOeNumber,
    this.replacesPartsNumber,
    this.warranty,
    this.interchargePartNumber,
    this.returnsPolicy,
    this.fitNotes,
  });

  int id;
  String productNumber;
  String title;
  String description;
  int price;
  String category;
  String brand;
  String modal;
  String location;
  String recommendedUse;
  String assembly;
  String lightSource;
  String colorFinish;
  String productFit;
  String qualitySold;
  String replacesOeNumber;
  String replacesPartsNumber;
  String warranty;
  String interchargePartNumber;
  String returnsPolicy;
  String fitNotes;

  factory SingleProduct.fromMap(Map<String, dynamic> json) => SingleProduct(
    id: json["id"],
    productNumber: json["product_number"],
    description: json["description"],
    title: json["title"],
    price: json["price"],
    category: json["category"],
    brand: json["brand"],
    modal: json["modal"],
    location: json["location"],
    recommendedUse: json["recommended_use"],
    assembly: json["assembly"],
    lightSource: json["light_source"],
    colorFinish: json["color_finish"],
    productFit: json["product_fit"],
    qualitySold: json["quality_sold"],
    replacesOeNumber: json["replaces_oe_number"],
    replacesPartsNumber: json["replaces_parts_number"],
    warranty: json["warranty"],
    interchargePartNumber: json["intercharge_part_number"],
    returnsPolicy: json["returns_policy"],
    fitNotes: json["fit_notes"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "product_number": productNumber,
    "title": title,
    "description": description,
    "price": price,
    "category": category,
    "brand": brand,
    "modal": modal,
    "location": location,
    "recommended_use": recommendedUse,
    "assembly": assembly,
    "light_source": lightSource,
    "color_finish": colorFinish,
    "product_fit": productFit,
    "quality_sold": qualitySold,
    "replaces_oe_number": replacesOeNumber,
    "replaces_parts_number": replacesPartsNumber,
    "warranty": warranty,
    "intercharge_part_number": interchargePartNumber,
    "returns_policy": returnsPolicy,
    "fit_notes": fitNotes,
  };
}

class Image {
  Image({
    this.id,
    this.image,
  });

  int id;
  String image;

  factory Image.fromMap(Map<String, dynamic> json) => Image(
    id: json["id"],
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "image": image,
  };
}
