import 'dart:convert'; // Untuk encode/decode JSON

class HealthRecord {
  final DateTime date;
  final String category;
  final String summary;
  final int riskLevel;
  final List<String> diagnosisList;
  final List<String> adviceList;
  final List<String> symptomTags;

  HealthRecord({
    required this.date,
    required this.category,
    required this.summary,
    required this.riskLevel,
    required this.diagnosisList,
    required this.adviceList,
    required this.symptomTags,
  });

  // 1. Ubah Object jadi Text (JSON) untuk disimpan
  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'category': category,
      'summary': summary,
      'riskLevel': riskLevel,
      'diagnosisList': diagnosisList,
      'adviceList': adviceList,
      'symptomTags': symptomTags,
    };
  }

  // 2. Ubah Text (JSON) jadi Object saat dibaca
  factory HealthRecord.fromMap(Map<String, dynamic> map) {
    return HealthRecord(
      date: DateTime.parse(map['date']),
      category: map['category'],
      summary: map['summary'],
      riskLevel: map['riskLevel'],
      diagnosisList: List<String>.from(map['diagnosisList']),
      adviceList: List<String>.from(map['adviceList']),
      symptomTags: List<String>.from(map['symptomTags']),
    );
  }

  String toJson() => json.encode(toMap());

  factory HealthRecord.fromJson(String source) => HealthRecord.fromMap(json.decode(source));
}

// Global variable (Akan kita isi nanti saat app mulai)
List<HealthRecord> globalHistory = [];