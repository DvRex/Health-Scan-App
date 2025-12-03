import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import Home Screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulasi loading 3 detik lalu pindah ke Home
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A3A4F), Color(0xFF2A9D8F)], // Dark blue to Teal gradient
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.monitor_heart_outlined, size: 100, color: Colors.white),
              const SizedBox(height: 24),
              const Text(
                "Health Scan",
                style: TextStyle(
                    fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Pemeriksaan kesehatan mandiri — saran awal berbasis aturan",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8)),
                ),
              ),
              const SizedBox(height: 60),
              const SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.white24,
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 20),
               Text(
                  "Memuat aplikasi...",
                  style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}