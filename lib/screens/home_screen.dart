import 'package:flutter/material.dart'; //Dasar Flutter seperti widget DLL
import '../core/app_theme.dart';       //Ambil Warna Dari app_theme
import 'profile_form_screen.dart';    //Halaman Tujuan untuk tombol supaya bisa berpidah halaman (seperti Impor)
import 'history_screen.dart';         // --------------------- // -----------------------------


class HomeScreen extends StatelessWidget {      // StatelessWidget Halaman diam artinya, tampilan tidak berubah-ubah
  const HomeScreen({super.key});                //Halaman Ini khusus menu home screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(               // appBar artinya tampilan paling atas pada website/Aplikasi
        title: const Row(           // Row > Kiri Kanan 
          children: [
            Icon(Icons.monitor_heart_outlined, color: AppColors.primary),
            SizedBox(width: 8),
            Text("Health Scan", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- JUDUL DUA WARNA (RICH TEXT) ---
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 28, 
                  height: 1.2,
                  fontFamily: 'Plus Jakarta Sans', // Pastikan nama font sama dengan di pubspec.yaml jika ada
                  color: AppColors.textPrimary
                ),
                children: [
                  TextSpan(
                    text: "Periksa Kesehatan\n",
                    style: TextStyle(
                      fontWeight: FontWeight.w800, // Extra Bold
                      color: Color(0xFF1A3A4F), // Navy Gelap
                    ),
                  ),
                  TextSpan(
                    text: "Anda Sendiri",
                    style: TextStyle(
                      fontWeight: FontWeight.w800, // Extra Bold
                      color: AppColors.primary, // Teal
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              "Dapatkan saran awal berdasarkan gejala yang Anda alami. Cepat, mudah, dan aman.",
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
            
            const SizedBox(height: 32),
            
            // --- TOMBOL UTAMA (MULAI) ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileFormScreen()));
                },
                icon: const Icon(Icons.assignment_add),
                label: const Text("Mulai Pemeriksaan"),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // --- TOMBOL SEKUNDER (RIWAYAT) ---
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                   Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const HistoryScreen())
                  );
                },
                icon: const Icon(Icons.history),
                label: const Text("Riwayat Pemeriksaan"),
              ),
            ),
            
            const SizedBox(height: 40),
            
            const Text("Fitur Utama", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            
            const SizedBox(height: 16),
            
            // --- FITUR CARDS ---
            _buildFeatureCard(Icons.analytics_outlined, "Analisis Gejala", "Berbasis aturan medis terpercaya."),
            const SizedBox(height: 12),
            _buildFeatureCard(Icons.shield_outlined, "Saran Aman", "Rekomendasi awal yang tepat."),
            const SizedBox(height: 12),
            _buildFeatureCard(Icons.receipt_long_outlined, "Riwayat Lengkap", "Simpan semua hasil pemeriksaan."),
          ],
        ),
      ),
    );
  }

  // Helper Widget untuk Card Fitur
  Widget _buildFeatureCard(IconData icon, String title, String subtitle) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}