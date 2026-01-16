import 'package:flutter/material.dart';
import 'services/auth_storage.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/admin_dashboard_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<Widget> _startScreen() async {
    final token = await AuthStorage.getToken();
    if (token != null && token.isNotEmpty) {
      final isAdmin = await AuthStorage.isAdmin();
      if (isAdmin) {
        return AdminDashboardScreen();
      }
      return HomeScreen();
    }
    return LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _startScreen(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data!;
        },
      ),
    );
  }
}
