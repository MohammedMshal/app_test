class Modal {
  Modal({
    this.id,
    this.title,
    this.brand,
  });

  int id;
  String title;
  int brand;

  factory Modal.fromMap(Map<String, dynamic> json) => Modal(
    id: json["id"],
    title: json["title"],
    brand: json["brand"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "brand": brand,
  };
}