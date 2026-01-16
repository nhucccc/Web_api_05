class MenuItem {
  final int id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final bool isVegetarian;
  final bool isSpicy;
  final int preparationTime;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.isVegetarian,
    required this.isSpicy,
    required this.preparationTime,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      isVegetarian: json['is_vegetarian'] ?? false,
      isSpicy: json['is_spicy'] ?? false,
      preparationTime: json['preparation_time'] ?? 0,
    );
  }
}
