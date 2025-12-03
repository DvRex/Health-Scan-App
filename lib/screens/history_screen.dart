import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import 'package:health_check/models/history_models.dart';
import 'result_screen.dart'; // Import Result Screen
import '../core/storage_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  
  // Helper Warna
  Color _getStatusColor(String category) {
    switch (category) {
      case 'DARURAT': return const Color(0xFFE53935);
      case 'SEGERA DIPERIKSA': return const Color(0xFFFF9800);
      case 'PERLU PERHATIAN': return const Color(0xFFFBC02D);
      case 'AMAN': return const Color(0xFF43A047);
      default: return Colors.grey;
    }
  }

  // Helper Icon
  IconData _getStatusIcon(String category) {
    switch (category) {
      case 'DARURAT': return Icons.warning_rounded;
      case 'SEGERA DIPERIKSA': return Icons.priority_high_rounded;
      case 'PERLU PERHATIAN': return Icons.info_outline_rounded;
      case 'AMAN': return Icons.check_circle_outline_rounded;
      default: return Icons.help_outline;
    }
  }

  String _formatDate(DateTime date) {
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return "${date.day} ${months[date.month - 1]} ${date.year} • ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

void _deleteHistory(int index) {
    setState(() {
      globalHistory.removeAt(index);
    });
    // Update penyimpanan setelah dihapus
    StorageService.saveHistory(globalHistory); 
    
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Riwayat dihapus")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text("Riwayat Pemeriksaan", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        backgroundColor: const Color(0xFFF7F9FC),
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.arrow_back, size: 20, color: AppColors.textPrimary),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: globalHistory.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_edu, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text("Belum ada riwayat tersimpan", style: TextStyle(color: Colors.grey.shade500)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: globalHistory.length,
              itemBuilder: (context, index) {
                final item = globalHistory[index];
                final Color statusColor = _getStatusColor(item.category);
                final IconData statusIcon = _getStatusIcon(item.category);

                return Dismissible(
                  key: Key(item.date.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _deleteHistory(index),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete, color: Colors.red),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      // NAVIGASI KE RESULT SCREEN (MODE VIEW)
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => ResultScreen(historyData: item)
                        )
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Icon Box
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(statusIcon, color: statusColor, size: 28),
                          ),
                          
                          const SizedBox(width: 16),

                          // 2. Info Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title & Date
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.category,
                                      style: TextStyle(
                                        color: statusColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatDate(item.date),
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                                ),
                                const SizedBox(height: 12),

                                // 3. Symptom Chips (Tag Gejala)
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: item.symptomTags.take(3).map((tag) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        tag,
                                        style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}