import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'screens/splash_screen.dart';
import 'core/storage_service.dart'; // Import service penyimpanan
import 'models/history_models.dart';

void main() async {
  // 1. Wajib ada jika fungsi main menggunakan 'async'
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Load data lama dari memori HP ke variabel global sebelum aplikasi muncul
  globalHistory = await StorageService.loadHistory();

  runApp(const HealthCheckApp());
}

class HealthCheckApp extends StatelessWidget {
  const HealthCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Scan',
      debugShowCheckedModeBanner: false,
      
      // Tema aplikasi
      theme: AppTheme.lightTheme, 
      
      home: const SplashScreen(),
    );
  }
}