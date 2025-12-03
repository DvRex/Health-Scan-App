import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import 'package:health_check/models/history_models.dart';
import 'home_screen.dart';
import '../core/storage_service.dart';

class ResultScreen extends StatefulWidget {
  // Opsional: Salah satu harus diisi
  final Map<String, dynamic>? answers;      // Untuk Pemeriksaan Baru
  final HealthRecord? historyData;          // Untuk Melihat Riwayat

  const ResultScreen({super.key, this.answers, this.historyData});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late String _category;
  late Color _categoryColor;
  late String _description;
  late List<String> _diagnosisList;
  late List<String> _adviceList;
  late int _riskLevel;
  late List<String> _symptomTags; // Untuk disimpan ke history

  @override
  void initState() {
    super.initState();
    if (widget.historyData != null) {
      // MODE 1: LIHAT RIWAYAT (Load data dari history)
      _loadFromHistory();
    } else if (widget.answers != null) {
      // MODE 2: ANALISIS BARU (Hitung dari jawaban)
      _analyzeResults();
    }
  }

  // Load Data Lama
  void _loadFromHistory() {
    final data = widget.historyData!;
    _category = data.category;
    _diagnosisList = data.diagnosisList;
    _adviceList = data.adviceList;
    _riskLevel = data.riskLevel;
    
    // Set warna & deskripsi ulang berdasarkan data lama
    _setCategoryStyle(_category);
  }

  // Analisis Data Baru
  void _analyzeResults() {
    final a = widget.answers!;
    _diagnosisList = [];
    _adviceList = [];
    _symptomTags = [];

    // 1. Deteksi Gejala & Buat Tags
    if (a['demam'] == true) {
      String suhu = a['suhu'] ?? '';
      _diagnosisList.add("Demam ($suhu)");
      _symptomTags.add("Demam");
    }
    if (a['sesak'] == true) {
      _diagnosisList.add("Sesak Napas (Bahaya)");
      _symptomTags.add("Sesak Napas");
    }
    if (a['batuk'] == true) {
      _diagnosisList.add(a['jenis_batuk'] ?? "Batuk");
      _symptomTags.add("Batuk");
    }
    if (a['anosmia'] == true) {
      _diagnosisList.add("Kehilangan Indera Penciuman");
      _symptomTags.add("Anosmia");
    }
    if (a['pilek'] == true) {
      _diagnosisList.add("Pilek/Hidung Tersumbat");
      _symptomTags.add("Pilek");
    }
    if (a['tenggorokan'] == true) {
      _diagnosisList.add("Sakit Tenggorokan");
      _symptomTags.add("Sakit Tenggorokan");
    }
    if (a['pencernaan'] != null && a['pencernaan'] != 'Tidak Ada') {
      _diagnosisList.add("Gangguan Pencernaan (${a['pencernaan']})");
      _symptomTags.add("Pencernaan");
    }

    if (_symptomTags.isEmpty) _symptomTags.add("Tidak ada gejala");

    // 2. Tentukan Kategori
    if (a['sesak'] == true || (a['suhu'] != null && a['suhu'].contains('> 39'))) {
      _category = "DARURAT";
      _riskLevel = 3;
      _adviceList = [
        "Segera kunjungi IGD Rumah Sakit terdekat.",
        "Jangan mengemudi sendiri.",
        "Hubungi layanan darurat jika memburuk.",
      ];
    } else if (a['demam'] == true || a['anosmia'] == true || (a['batuk'] == true && a['jenis_batuk'] == 'Batuk Berdarah')) {
      _category = "SEGERA DIPERIKSA";
      _riskLevel = 2;
      _adviceList = [
        "Kunjungi dokter umum dalam 24 jam.",
        "Lakukan isolasi mandiri.",
        "Pantau suhu tubuh berkala."
      ];
    } else if (a['pilek'] == true || a['tenggorokan'] == true || (a['pencernaan'] != null && a['pencernaan'] != 'Tidak Ada')) {
      _category = "PERLU PERHATIAN";
      _riskLevel = 1;
      _adviceList = [
        "Istirahat total minimal 7-8 jam.",
        "Perbanyak minum air putih.",
        "Konsumsi vitamin C."
      ];
    } else {
      _category = "AMAN";
      _riskLevel = 0;
      _diagnosisList.add("Kondisi Fisik Baik");
      _adviceList = [
        "Pertahankan gaya hidup sehat.",
        "Rutin berolahraga."
      ];
    }

    _setCategoryStyle(_category);
  }

  void _setCategoryStyle(String category) {
    switch (category) {
      case 'DARURAT':
        _categoryColor = const Color(0xFFE53935);
        _description = "Kondisi membutuhkan penanganan medis segera.";
        break;
      case 'SEGERA DIPERIKSA':
        _categoryColor = const Color(0xFFFF9800);
        _description = "Gejala serius, segera konsultasi ke dokter.";
        break;
      case 'PERLU PERHATIAN':
        _categoryColor = const Color(0xFFFBC02D);
        _description = "Kondisi ringan, pantau dan istirahat.";
        break;
      case 'AMAN':
        _categoryColor = const Color(0xFF43A047);
        _description = "Tidak ditemukan gejala signifikan.";
        break;
      default:
        _categoryColor = Colors.grey;
        _description = "";
    }
  }

  Future<void> _saveResult() async {
    // 1. Masukkan ke variabel global (RAM)
    globalHistory.insert(0, HealthRecord(
      date: DateTime.now(),
      category: _category,
      summary: _diagnosisList.first,
      riskLevel: _riskLevel,
      diagnosisList: _diagnosisList,
      adviceList: _adviceList,
      symptomTags: _symptomTags,
    ));

    // 2. SIMPAN PERMANEN KE STORAGE HP
    await StorageService.saveHistory(globalHistory);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Hasil pemeriksaan berhasil disimpan permanen")),
      );

      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (context) => const HomeScreen()), 
        (route) => false
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Hasil pemeriksaan berhasil disimpan")),
    );

    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (context) => const HomeScreen()), 
      (route) => false
    );
  }

  @override
  Widget build(BuildContext context) {
    // Cek apakah ini mode history (tombol simpan disembunyikan)
    bool isHistoryMode = widget.historyData != null;

    return Scaffold(
      backgroundColor: _categoryColor, // Full background color header style (optional, like reference)
      appBar: AppBar(
        title: Text(isHistoryMode ? "Detail Riwayat" : "Hasil Analisis", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header Area
          Container(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                Icon(
                  _riskLevel == 0 ? Icons.check_circle_outline : 
                  _riskLevel == 3 ? Icons.warning_amber_rounded : Icons.info_outline,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Text("Hasil Pemeriksaan", style: TextStyle(color: Colors.white.withOpacity(0.8))),
                const SizedBox(height: 5),
                Text(
                  _category,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2),
                ),
              ],
            ),
          ),
          
          // White Sheet Content
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Deskripsi
                    Text(
                      _description,
                      style: const TextStyle(fontSize: 16, color: AppColors.textPrimary, height: 1.5),
                    ),
                    const SizedBox(height: 24),

                    // Card Diagnosa
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.monitor_heart_outlined, color: _categoryColor),
                              const SizedBox(width: 8),
                              const Text("Diagnosa Gejala", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ..._diagnosisList.map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Icon(Icons.circle, size: 6, color: _categoryColor),
                                const SizedBox(width: 10),
                                Expanded(child: Text(e, style: const TextStyle(fontWeight: FontWeight.w500))),
                              ],
                            ),
                          )).toList(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Card Saran
                    const Text("Saran untuk Anda", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary)),
                    const SizedBox(height: 12),
                    ..._adviceList.asMap().entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: _categoryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Text("${entry.key + 1}", style: TextStyle(fontWeight: FontWeight.bold, color: _categoryColor)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(entry.value, style: const TextStyle(height: 1.4))),
                        ],
                      ),
                    )).toList(),

                    const SizedBox(height: 40),

                    // Tombol Simpan (Hanya muncul jika bukan mode history)
                    if (!isHistoryMode) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveResult,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _categoryColor, // Sesuaikan warna tombol dengan status
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Simpan Hasil", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: _categoryColor),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text("Mulai Pemeriksaan Baru", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _categoryColor)),
                        ),
                      ),
                    ],
                    
                    // Jika History Mode, tombol Back saja cukup (sudah ada di AppBar) atau tombol Home
                    if (isHistoryMode)
                       SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                             Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Kembali", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}