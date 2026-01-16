import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/menu_item.dart';
import 'admin_menu_form_screen.dart';

class AdminMenuManagementScreen extends StatefulWidget {
  @override
  State<AdminMenuManagementScreen> createState() =>
      _AdminMenuManagementScreenState();
}

class _AdminMenuManagementScreenState
    extends State<AdminMenuManagementScreen> {
  Future<List<MenuItem>>? _menuFuture;

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  void _loadMenu() {
    setState(() {
      _menuFuture = ApiService.getMenus();
    });
  }

  Future<void> _deleteMenuItem(MenuItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa món "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ApiService.deleteMenuItem(item.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã xóa món "${item.name}"'),
              backgroundColor: Colors.green,
            ),
          );
          _loadMenu();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceAll('Exception: ', '')),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản Lý Menu'),
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AdminMenuFormScreen(),
            ),
          );
          if (result == true) {
            _loadMenu();
          }
        },
        icon: Icon(Icons.add),
        label: Text('Thêm Món'),
        backgroundColor: Colors.orange.shade600,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange.shade50,
              Colors.white,
            ],
          ),
        ),
        child: FutureBuilder<List<MenuItem>>(
          future: _menuFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        size: 64, color: Colors.red.shade300),
                    SizedBox(height: 16),
                    Text(
                      'Không thể tải danh sách',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      snapshot.error.toString().replaceAll('Exception: ', ''),
                      style: TextStyle(color: Colors.grey.shade600),
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
                    Icon(Icons.restaurant,
                        size: 64, color: Colors.grey.shade300),
                    SizedBox(height: 16),
                    Text('Chưa có món ăn nào'),
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
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: item.imageUrl.isNotEmpty
                          ? Image.network(
                              item.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey.shade200,
                                  child: Icon(Icons.image_not_supported),
                                );
                              },
                            )
                          : Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey.shade200,
                              child: Icon(Icons.restaurant),
                            ),
                    ),
                    title: Text(
                      item.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    AdminMenuFormScreen(item: item),
                              ),
                            );
                            if (result == true) {
                              _loadMenu();
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteMenuItem(item),
                        ),
                      ],
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
