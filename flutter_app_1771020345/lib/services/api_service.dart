import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'auth_storage.dart';
import '../models/menu_item.dart';

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5087/api';
    }
    return 'http://10.0.2.2:5087/api';
  }

  static Future<String> register(String email, String password, String fullName) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'fullName': fullName,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['message'] ?? 'Đăng ký thành công';
    } else if (res.statusCode == 400) {
      throw Exception('Email đã tồn tại');
    } else {
      throw Exception('Lỗi đăng ký: ${res.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return {
        'token': data['token'],
        'user': data['user'],
      };
    } else if (res.statusCode == 401) {
      throw Exception('Email hoặc mật khẩu không đúng');
    } else {
      throw Exception('Lỗi kết nối: ${res.statusCode}');
    }
  }

  static Future<List<MenuItem>> getMenus() async {
    final token = await AuthStorage.getToken();
    
    print('🔑 Token: $token');
    print('🌐 URL: $baseUrl/menu-items');

    final res = await http.get(
      Uri.parse('$baseUrl/menu-items'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print('📡 Status Code: ${res.statusCode}');
    print('📦 Response Body: ${res.body}');

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      
      // Kiểm tra nếu response có field 'data' (pagination format)
      if (data is Map && data.containsKey('data')) {
        final List menuItems = data['data'];
        print('✅ Found ${menuItems.length} items in data field');
        return menuItems.map((e) => MenuItem.fromJson(e)).toList();
      } 
      // Nếu không, response là array trực tiếp
      else if (data is List) {
        print('✅ Found ${data.length} items in array');
        return data.map((e) => MenuItem.fromJson(e)).toList();
      }
      
      print('❌ Unknown format: $data');
      throw Exception('Format dữ liệu không đúng');
    } else if (res.statusCode == 401) {
      throw Exception('Phiên đăng nhập hết hạn');
    } else {
      throw Exception('Không thể tải danh sách món ăn: ${res.statusCode}');
    }
  }

  // ADMIN: Create menu item
  static Future<MenuItem> createMenuItem(Map<String, dynamic> data) async {
    final token = await AuthStorage.getToken();

    final res = await http.post(
      Uri.parse('$baseUrl/menu-items'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (res.statusCode == 200) {
      final item = jsonDecode(res.body);
      return MenuItem.fromJson(item);
    } else {
      throw Exception('Không thể tạo món ăn: ${res.statusCode}');
    }
  }

  // ADMIN: Update menu item
  static Future<MenuItem> updateMenuItem(int id, Map<String, dynamic> data) async {
    final token = await AuthStorage.getToken();

    final res = await http.put(
      Uri.parse('$baseUrl/menu-items/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (res.statusCode == 200) {
      final item = jsonDecode(res.body);
      return MenuItem.fromJson(item);
    } else {
      throw Exception('Không thể cập nhật món ăn: ${res.statusCode}');
    }
  }

  // ADMIN: Delete menu item
  static Future<void> deleteMenuItem(int id) async {
    final token = await AuthStorage.getToken();

    final res = await http.delete(
      Uri.parse('$baseUrl/menu-items/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Không thể xóa món ăn: ${res.statusCode}');
    }
  }
}
