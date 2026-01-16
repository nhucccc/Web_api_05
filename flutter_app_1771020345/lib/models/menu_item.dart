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

  // Danh sách ảnh mặc định đẹp
  static final List<String> _defaultImages = [
    'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600&q=80', // Pizza
    'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&q=80', // Burger
    'https://images.unsplash.com/photo-1563379926898-05f4575a45d8?w=600&q=80', // Pasta
    'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=600&q=80', // Sushi
    'https://images.unsplash.com/photo-1600891964092-4316c288032e?w=600&q=80', // Steak
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&q=80', // Salad
    'https://images.unsplash.com/photo-1559314809-0d155014e29e?w=600&q=80', // Phở
    'https://images.unsplash.com/photo-1626074353765-517a681e40be?w=600&q=80', // Bánh mì
    'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=600&q=80', // Cơm
    'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&q=80', // Ramen
    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&q=80', // Sandwich
    'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=600&q=80', // Chicken
    'https://images.unsplash.com/photo-1559847844-5315695dadae?w=600&q=80', // Pad Thai
    'https://images.unsplash.com/photo-1555126634-323283e090fa?w=600&q=80', // Bún
    'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=600&q=80', // Tempura
    'https://images.unsplash.com/photo-1590301157890-4810ed352733?w=600&q=80', // Bibimbap
    'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=600&q=80', // Cake
    'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&q=80', // Ice cream
    'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=600&q=80', // Coffee
    'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=600&q=80', // Tea
    'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=600&q=80', // Soup
    'https://images.unsplash.com/photo-1565680018434-b513d5e5fd47?w=600&q=80', // Shrimp
    'https://images.unsplash.com/photo-1559737558-2f5a35f4523e?w=600&q=80', // Fish
    'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=600&q=80', // Spring roll
    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600&q=80', // Food
  ];

  // Lấy ảnh mặc định theo ID
  static String getDefaultImage(int id) {
    return _defaultImages[(id - 1) % _defaultImages.length];
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    // Hỗ trợ cả snake_case và camelCase
    var imageUrl = json['image_url'] ?? json['imageUrl'] ?? '';
    final isVegetarian = json['is_vegetarian'] ?? json['isVegetarian'] ?? false;
    final isSpicy = json['is_spicy'] ?? json['isSpicy'] ?? false;
    final preparationTime = json['preparation_time'] ?? json['preparationTime'] ?? 0;
    final id = json['id'] as int;
    
    // Nếu không có ảnh hoặc ảnh không hợp lệ, dùng ảnh mặc định
    if (imageUrl.isEmpty || 
        imageUrl == 'string' || 
        !imageUrl.startsWith('http')) {
      imageUrl = getDefaultImage(id);
      print('🖼️ Sử dụng ảnh mặc định cho món #$id: $imageUrl');
    } else {
      print('🖼️ Sử dụng ảnh từ API: $imageUrl');
    }
    
    return MenuItem(
      id: id,
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      description: json['description'] ?? '',
      imageUrl: imageUrl,
      isVegetarian: isVegetarian,
      isSpicy: isSpicy,
      preparationTime: preparationTime,
    );
  }
}
