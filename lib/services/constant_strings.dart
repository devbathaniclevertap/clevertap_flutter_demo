import 'package:flutter_clevertap_demo/models/product.dart';

final List<Product> products = [
  Product(
      id: "PRD001",
      name: "Brightening Raspberry Body Wash | Vitamin...",
      price: "399",
      imageUrl:
          "https://www.mcaffeine.com/cdn/shop/files/card_2_b20d3e55-71e1-466c-93e6-43660b6f7950.jpg?v=1747316744&width=1445",
      tag: "BEST SELLER",
      rating: 4.6,
      reviewCount: 86,
      description: "Skin Brightening | Refreshing Fruity Frag..."),
  Product(
      id: "PRD002",
      name: "Brightening Tan Removal 1% Kojic Aci...",
      price: "499",
      imageUrl:
          "https://www.mcaffeine.com/cdn/shop/files/card_6_f39f8adb-bcad-4848-ab04-2348e799aa5d.jpg?v=1748427296&width=1445",
      tag: "NEW",
      rating: 4.5,
      reviewCount: 41,
      description: "De-Tan & Brightening | Reduces Melanin Pro..."),
  Product(
      id: "PRD003",
      name: "Gentle Face Cleanser",
      price: "499",
      imageUrl:
          "https://www.mcaffeine.com/cdn/shop/files/coffee_face_wah.jpg?v=1734688170",
      rating: 4.7,
      reviewCount: 102,
      description: "Deep Cleansing | For All Skin Types..."),
  Product(
      id: "PRD004",
      name: "SPF 50+ Sunscreen Lotion",
      price: "699",
      imageUrl:
          "https://www.mcaffeine.com/cdn/shop/files/de_tan_sunscreen.jpg?v=1734689206",
      tag: "BEST SELLER",
      rating: 4.8,
      reviewCount: 150,
      description: "Broad Spectrum | Non-Greasy Formula..."),
];

final List<Map<String, String>> categories = [
  {
    "name": "Body Lotion",
    "image": "https://www.mcaffeine.com/cdn/shop/files/card_1b.jpg?v=1732871256"
  },
  {
    "name": "Body Scrub",
    "image":
        "https://www.mcaffeine.com/cdn/shop/products/PrimaryImage_2_066c313a-8242-4eda-95ca-2edea4295872.jpg?v=1669275410"
  },
  {
    "name": "Face Care",
    "image":
        "https://www.mcaffeine.com/cdn/shop/files/pigmentation_face_wash.jpg?v=1734690262"
  },
];

final List<Map<String, String>> trending = [
  {
    "name": "SPF Body Lotion",
    "image":
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGLe9CujG9mQUx9eP8ztJuho2WYfH6cyrtyg&s"
  },
  {
    "name": "Super Glow Mask",
    "image":
        "https://www.mcaffeine.com/cdn/shop/files/card_1_1bd8adb0-bfea-4027-973a-ecbfa59dd02e_1024x1024.jpg?v=1736425782"
  },
  {
    "name": "Perfume Body Lotion",
    "image":
        "https://m.media-amazon.com/images/I/61j-35hgheL._UF1000,1000_QL80_.jpg"
  },
  {
    "name": "Body Scrub",
    "image":
        "https://www.mcaffeine.com/cdn/shop/files/Card_1_15.jpg?v=1725357768"
  },
];
