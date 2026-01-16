import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_storage.dart';

class EmployeeApi {
  static const String baseUrl = 'http://10.0.2.2:5087/api/employees';

  static Future<List<dynamic>> getEmployees() async {
    final token = await AuthStorage.getToken();

    if (token == null) {
      throw Exception('TOKEN IS NULL');
    }

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('UNAUTHORIZED');
    } else {
      throw Exception('FAILED TO LOAD EMPLOYEES');
    }
  }
}
