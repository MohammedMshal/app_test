class Brand {
  Brand({
    this.id,
    this.title,
    this.image,
  });

  int id;
  String title;
  String image;

  factory Brand.fromMap(Map<String, dynamic> json) => Brand(
    id: json["id"],
    title: json["title"],
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "image": image,
  };
}

