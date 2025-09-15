class ProductEntity {
  final String? id;
  final String? name;
  final String? description;
  final double? price;
  final String? imageUrl;
  final String? category;
  final int? quantity;
  final DateTime? createdAt;

  ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.quantity,
    required this.createdAt,
  });
}