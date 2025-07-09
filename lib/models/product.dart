class Product {
  final String id;
  final String name;
  final String price;
  final String imageUrl;
  final String? tag;
  final double? rating;
  final int? reviewCount;
  final String? description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.tag,
    this.rating,
    this.reviewCount,
    this.description,
  });
}
