import 'models/menu_item.dart';

void main() {
  print('🧪 Testing MenuItem with invalid URLs...\n');
  
  // Test case 1: URL_HINH_1
  final json1 = {
    'id': 1,
    'name': 'Phở Bò',
    'price': 50000,
    'description': 'Phở bò truyền thống',
    'image_url': 'URL_HINH_1',
    'is_vegetarian': false,
    'is_spicy': false,
    'preparation_time': 15,
  };
  
  final item1 = MenuItem.fromJson(json1);
  print('Test 1: ${item1.name}');
  print('  Input: URL_HINH_1');
  print('  Output: ${item1.imageUrl}');
  print('  ✅ ${item1.imageUrl.startsWith("https://") ? "PASS" : "FAIL"}\n');
  
  // Test case 2: Empty string
  final json2 = {
    'id': 2,
    'name': 'Bún Chả',
    'price': 45000,
    'description': 'Bún chả Hà Nội',
    'image_url': '',
    'is_vegetarian': false,
    'is_spicy': false,
    'preparation_time': 20,
  };
  
  final item2 = MenuItem.fromJson(json2);
  print('Test 2: ${item2.name}');
  print('  Input: (empty)');
  print('  Output: ${item2.imageUrl}');
  print('  ✅ ${item2.imageUrl.startsWith("https://") ? "PASS" : "FAIL"}\n');
  
  // Test case 3: Valid URL
  final json3 = {
    'id': 3,
    'name': 'Cơm Tấm',
    'price': 40000,
    'description': 'Cơm tấm sườn',
    'image_url': 'https://example.com/image.jpg',
    'is_vegetarian': false,
    'is_spicy': false,
    'preparation_time': 10,
  };
  
  final item3 = MenuItem.fromJson(json3);
  print('Test 3: ${item3.name}');
  print('  Input: https://example.com/image.jpg');
  print('  Output: ${item3.imageUrl}');
  print('  ✅ ${item3.imageUrl == "https://example.com/image.jpg" ? "PASS" : "FAIL"}\n');
  
  // Test nhiều món
  print('🎨 Testing multiple items...\n');
  for (int i = 1; i <= 10; i++) {
    final json = {
      'id': i,
      'name': 'Món $i',
      'price': 50000,
      'description': 'Mô tả',
      'image_url': 'URL_HINH_$i',
      'is_vegetarian': false,
      'is_spicy': false,
      'preparation_time': 15,
    };
    
    final item = MenuItem.fromJson(json);
    print('Món #$i: ${item.imageUrl.substring(0, 60)}...');
  }
  
  print('\n✅ All tests completed!');
}
