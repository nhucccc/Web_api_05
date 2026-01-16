import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/menu_item.dart';

class UpdateImagesScreen extends StatefulWidget {
  @override
  _UpdateImagesScreenState createState() => _UpdateImagesScreenState();
}

class _UpdateImagesScreenState extends State<UpdateImagesScreen> {
  bool _isUpdating = false;
  String _status = '';
  int _updatedCount = 0;
  
  // Danh sách hình ảnh đẹp
  final List<String> _imageUrls = [
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
    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600&q=80', // Food general
  ];

  Future<void> _updateAllImages() async {
    setState(() {
      _isUpdating = true;
      _status = 'Đang tải danh sách món ăn...';
      _updatedCount = 0;
    });

    try {
      // Lấy danh sách tất cả món ăn
      final items = await ApiService.getMenus();
      
      setState(() {
        _status = 'Tìm thấy ${items.length} món ăn. Đang cập nhật...';
      });

      // Cập nhật từng món
      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        final imageUrl = _imageUrls[i % _imageUrls.length];
        
        setState(() {
          _status = 'Đang cập nhật ${item.name} (${i + 1}/${items.length})...';
        });

        try {
          await ApiService.updateMenuItem(item.id, {
            'name': item.name,
            'price': item.price,
            'description': item.description,
            'imageUrl': imageUrl,
            'isVegetarian': item.isVegetarian,
            'isSpicy': item.isSpicy,
            'preparationTime': item.preparationTime,
          });
          
          setState(() {
            _updatedCount++;
          });
          
          // Delay nhỏ để không spam API
          await Future.delayed(Duration(milliseconds: 200));
        } catch (e) {
          print('❌ Lỗi cập nhật ${item.name}: $e');
        }
      }

      setState(() {
        _status = '✅ Hoàn thành! Đã cập nhật $_updatedCount/${items.length} món ăn.';
        _isUpdating = false;
      });

      // Hiển thị dialog thành công
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 32),
                SizedBox(width: 12),
                Text('Thành công!'),
              ],
            ),
            content: Text(
              'Đã cập nhật hình ảnh cho $_updatedCount món ăn.\n\nVui lòng quay lại danh sách món ăn để xem kết quả.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        _status = '❌ Lỗi: $e';
        _isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập Nhật Hình Ảnh'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image,
                  size: 100,
                  color: Colors.blue.shade400,
                ),
                SizedBox(height: 32),
                Text(
                  'Cập Nhật Hình Ảnh Cho Tất Cả Món Ăn',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Công cụ này sẽ tự động cập nhật hình ảnh đẹp từ Unsplash cho tất cả món ăn trong hệ thống.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 48),
                if (_isUpdating)
                  Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 24),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              _status,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (_updatedCount > 0) ...[
                              SizedBox(height: 12),
                              Text(
                                'Đã cập nhật: $_updatedCount món',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      if (_status.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: _status.contains('✅')
                                ? Colors.green.shade50
                                : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _status.contains('✅')
                                  ? Colors.green.shade300
                                  : Colors.red.shade300,
                            ),
                          ),
                          child: Text(
                            _status,
                            style: TextStyle(
                              fontSize: 14,
                              color: _status.contains('✅')
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade600,
                              Colors.purple.shade600,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade300,
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: _updateAllImages,
                          icon: Icon(Icons.refresh, size: 28),
                          label: Text(
                            'Bắt Đầu Cập Nhật',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
