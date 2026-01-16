import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/menu_item.dart';
import 'menu_detail_screen.dart';

class MenuListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh Sách Món Ăn'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
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
        child: FutureBuilder<List<MenuItem>>(
          future: ApiService.getMenus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Đang tải danh sách món ăn...',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade300,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Không thể tải danh sách món ăn',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      snapshot.error.toString().replaceAll('Exception: ', ''),
                      style: TextStyle(color: Colors.grey.shade600),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                      label: Text('Quay lại'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }

            final items = snapshot.data!;

            if (items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant,
                      size: 64,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Chưa có món ăn nào',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final item = items[i];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MenuDetailScreen(item: item),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: item.imageUrl.isNotEmpty
                                ? Image.network(
                                    item.imageUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey.shade200,
                                        child: Icon(
                                          Icons.image_not_supported,
                                          color: Colors.grey.shade400,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey.shade200,
                                    child: Icon(
                                      Icons.restaurant,
                                      color: Colors.grey.shade400,
                                      size: 32,
                                    ),
                                  ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '\$${item.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade600,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: item.isVegetarian
                                            ? Colors.green.shade100
                                            : Colors.red.shade100,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            item.isVegetarian
                                                ? Icons.eco
                                                : Icons.restaurant,
                                            size: 12,
                                            color: item.isVegetarian
                                                ? Colors.green.shade700
                                                : Colors.red.shade700,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            item.isVegetarian ? 'Chay' : 'Mặn',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: item.isVegetarian
                                                  ? Colors.green.shade700
                                                  : Colors.red.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: item.isSpicy
                                            ? Colors.orange.shade100
                                            : Colors.blue.shade100,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            item.isSpicy
                                                ? Icons.local_fire_department
                                                : Icons.ac_unit,
                                            size: 12,
                                            color: item.isSpicy
                                                ? Colors.orange.shade700
                                                : Colors.blue.shade700,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            item.isSpicy ? 'Cay' : 'Không cay',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: item.isSpicy
                                                  ? Colors.orange.shade700
                                                  : Colors.blue.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
