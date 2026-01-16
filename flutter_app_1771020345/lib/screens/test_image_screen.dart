import 'package:flutter/material.dart';

class TestImageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Các URL test
    final testUrls = [
      'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400',
      'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
      'https://via.placeholder.com/400x300/FF6B6B/FFFFFF?text=Test',
      'http://localhost:5087/images/test.jpg', // Local test
      '', // Empty URL test
      'invalid-url', // Invalid URL test
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Test Hình Ảnh'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: testUrls.length,
        itemBuilder: (context, index) {
          final url = testUrls[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Test ${index + 1}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'URL: ${url.isEmpty ? "(rỗng)" : url}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: url.isNotEmpty
                          ? Image.network(
                              url,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  print('✅ Image loaded: $url');
                                  return child;
                                }
                                print('⏳ Loading: $url');
                                return Container(
                                  color: Colors.grey.shade200,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                        SizedBox(height: 8),
                                        Text('Đang tải...'),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                print('❌ Error loading: $url');
                                print('   Error: $error');
                                return Container(
                                  color: Colors.red.shade50,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                        size: 48,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Lỗi tải ảnh',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      SizedBox(height: 4),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        child: Text(
                                          error.toString(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.red.shade700,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey.shade200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey.shade400,
                                    size: 48,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'URL rỗng',
                                    style: TextStyle(color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
