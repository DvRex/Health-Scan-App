import 'package:shared_preferences/shared_preferences.dart';
import 'package:health_check/models/history_models.dart';


class StorageService {
  static const String _keyHistory = 'health_check_history';

  // Simpan List History ke HP
  static Future<void> saveHistory(List<HealthRecord> history) async {
    final prefs = await SharedPreferences.getInstance();
    // Ubah setiap item jadi teks JSON, lalu simpan sebagai List String
    List<String> jsonList = history.map((item) => item.toJson()).toList();
    await prefs.setStringList(_keyHistory, jsonList);
  }

  // Ambil Data dari HP saat App dibuka
  static Future<List<HealthRecord>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList(_keyHistory);

    if (jsonList == null) return [];

    // Ubah kembali dari teks JSON jadi Object HealthRecord
    return jsonList.map((item) => HealthRecord.fromJson(item)).toList();
  }
}