// To parse this JSON data, do
//
//     final productIconEntity = productIconEntityFromJson(jsonString);

import 'dart:convert';

ProductIconEntity productIconEntityFromJson(String str) =>
    ProductIconEntity.fromJson(json.decode(str));

String productIconEntityToJson(ProductIconEntity data) =>
    json.encode(data.toJson());

class ProductIconEntity {
  IconSection iconData;

  ProductIconEntity({
    required this.iconData,
  });

  factory ProductIconEntity.fromJson(Map<String, dynamic> json) =>
      ProductIconEntity(
        iconData: IconSection.fromJson(json["icon_data"]),
      );

  Map<String, dynamic> toJson() => {
        "icon_data": iconData.toJson(),
      };
}

class IconSection {
  List<IconsData> quickLinks;
  List<IconsData> productSection;
  List<IconsData> priceSection;
  List<IconsData> serviceSection;

  IconSection({
    required this.quickLinks,
    required this.productSection,
    required this.priceSection,
    required this.serviceSection,
  });

  factory IconSection.fromJson(Map<String, dynamic> json) => IconSection(
        quickLinks: List<IconsData>.from(
            json["quick_links"].map((x) => IconsData.fromJson(x))),
        productSection: List<IconsData>.from(
            json["product_section"].map((x) => IconsData.fromJson(x))),
        priceSection: List<IconsData>.from(
            json["price_section"].map((x) => IconsData.fromJson(x))),
        serviceSection: List<IconsData>.from(
            json["service_section"].map((x) => IconsData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "quick_links": List<dynamic>.from(quickLinks.map((x) => x.toJson())),
        "product_section":
            List<dynamic>.from(productSection.map((x) => x.toJson())),
        "price_section":
            List<dynamic>.from(priceSection.map((x) => x.toJson())),
        "service_section":
            List<dynamic>.from(serviceSection.map((x) => x.toJson())),
      };
}

class IconsData {
  String id;
  String title;
  String imageUrl;
  int position;
  int clicked;
  bool isAnimated;

  IconsData({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.position,
    required this.clicked,
    required this.isAnimated,
  });

  factory IconsData.fromJson(Map<String, dynamic> json) => IconsData(
        id: json["id"],
        title: json["title"],
        imageUrl: json["image_url"],
        position: json["position"],
        clicked: json["clicked"],
        isAnimated: json["is_animated"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image_url": imageUrl,
        "position": position,
        "clicked": clicked,
        "is_animated": isAnimated,
      };
}
