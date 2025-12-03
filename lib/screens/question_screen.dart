import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import 'result_screen.dart';
// Pastikan Anda nanti membuat file result_screen.dart atau hapus import ini jika belum ada
// import 'result_screen.dart'; 

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  // --- 1. CONFIGURATION ---
  int _currentIndex = 0;
  
  // Warna Tema (Konsisten dengan Profile Screen)
  final Color _uiTealColor = const Color(0xFF4DB6AC);
  final Color _uiTealLight = const Color(0xFFE0F2F1);

  // Menyimpan Jawaban Pengguna
  // Key: id pertanyaan, Value: jawaban
  final Map<String, dynamic> _answers = {};

// Daftar Pertanyaan Lengkap
  late final List<Map<String, dynamic>> _questions = [
    // 1. Demam (Trigger Pertanyaan Suhu)
    {
      'id': 'demam',
      'question': 'Apakah Anda merasakan demam atau menggigil?',
      'type': 'yes_no',
    },
    // 2. Detail Suhu (Hanya muncul jika Demam = Ya)
    {
      'id': 'suhu',
      'question': 'Berapa perkiraan suhu tubuh Anda?',
      'type': 'choice',
      'options': [
        '< 37°C (Normal)',
        '37°C - 38°C (Sedikit Panas)',
        '38°C - 39°C (Demam)',
        '> 39°C (Demam Tinggi)'
      ],
      'required_condition': {'id': 'demam', 'value': true}
    },
    
    // 3. Batuk (Trigger Pertanyaan Jenis Batuk)
    {
      'id': 'batuk',
      'question': 'Apakah Anda mengalami batuk?',
      'type': 'yes_no',
    },
    // 4. Jenis Batuk (Hanya muncul jika Batuk = Ya)
    {
      'id': 'jenis_batuk',
      'question': 'Seperti apa batuk yang Anda alami?',
      'type': 'choice',
      'options': ['Batuk Kering (Gatal)', 'Batuk Berdahak', 'Batuk Berdarah'],
      'required_condition': {'id': 'batuk', 'value': true}
    },

    // 5. Pernapasan (Penting untuk deteksi darurat)
    {
      'id': 'sesak',
      'question': 'Apakah Anda merasa sesak napas atau dada terasa berat?',
      'type': 'yes_no',
    },

    // 6. Gejala THT (Telinga Hidung Tenggorokan)
    {
      'id': 'pilek',
      'question': 'Apakah Anda mengalami pilek atau hidung tersumbat?',
      'type': 'yes_no',
    },
    {
      'id': 'tenggorokan',
      'question': 'Apakah tenggorokan Anda terasa sakit atau nyeri saat menelan?',
      'type': 'yes_no',
    },

    // 7. Indera (Gejala Khas Virus tertentu)
    {
      'id': 'anosmia',
      'question': 'Apakah Anda kehilangan indera penciuman atau perasa secara tiba-tiba?',
      'type': 'yes_no',
    },

    // 8. Pencernaan
    {
      'id': 'pencernaan',
      'question': 'Apakah Anda mengalami gangguan pencernaan?',
      'type': 'dropdown',
      'options': [
        'Tidak Ada', 
        'Mual atau Muntah', 
        'Diare', 
        'Nyeri Lambung / Maag',
        'Sembelit'
      ],
    },

    // 9. Fisik Umum
    {
      'id': 'lelah',
      'question': 'Apakah Anda merasa sangat lelah atau nyeri otot sekujur tubuh?',
      'type': 'yes_no',
    },

    // 10. Riwayat Kontak/Perjalanan
    {
      'id': 'kontak',
      'question': 'Apakah Anda bepergian ke luar kota atau kontak dengan orang sakit dalam 14 hari terakhir?',
      'type': 'yes_no',
    },

    // 11. Durasi Gejala
    {
      'id': 'durasi',
      'question': 'Berapa hari gejala ini sudah berlangsung?',
      'type': 'number',
      'hint': 'Contoh: 3',
      'suffix': 'Hari'
    },

    // 12. Skala Keparahan Total
    {
      'id': 'skala_sakit',
      'question': 'Secara umum, seberapa buruk kondisi badan Anda saat ini?',
      'type': 'scale', // Slider 0-10
      'min': 0,
      'max': 10,
    },
  ];

  // --- 2. LOGIC NAVIGATION ---

  void _nextPage() {
    // 1. Validasi: User harus mengisi jawaban sebelum lanjut
    final currentQ = _questions[_currentIndex];
    if (_answers[currentQ['id']] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon isi jawaban terlebih dahulu")),
      );
      return;
    }

    // 2. Tentukan Index Selanjutnya
    int nextIndex = _currentIndex + 1;

    // 3. Logic Loncat Pertanyaan (Skip Logic)
    // Cek apakah pertanyaan berikutnya punya syarat (required_condition)
    while (nextIndex < _questions.length) {
      final nextQ = _questions[nextIndex];
      if (nextQ.containsKey('required_condition')) {
        final condition = nextQ['required_condition'];
        final requiredId = condition['id'];
        final requiredValue = condition['value'];

        // Jika jawaban user TIDAK sesuai syarat, kita skip pertanyaan ini
        if (_answers[requiredId] != requiredValue) {
          nextIndex++; // Loncat lagi ke pertanyaan depannya
          continue; // Cek lagi loop berikutnya
        }
      }
      break; // Jika tidak ada syarat atau syarat terpenuhi, stop looping
    }

    // 4. Navigasi
    if (nextIndex < _questions.length) {
      setState(() {
        _currentIndex = nextIndex;
      });
    } else {
      _finishAssessment();
    }
  }

  void _prevPage() {
    if (_currentIndex > 0) {
      // Logic mundur juga harus pintar (skip balik pertanyaan yang disembunyikan)
      int prevIndex = _currentIndex - 1;
      
      while (prevIndex >= 0) {
        final prevQ = _questions[prevIndex];
        if (prevQ.containsKey('required_condition')) {
          final condition = prevQ['required_condition'];
          if (_answers[condition['id']] != condition['value']) {
            prevIndex--;
            continue;
          }
        }
        break;
      }

      setState(() {
        _currentIndex = prevIndex;
      });
    } else {
      Navigator.pop(context); // Kembali ke Profile jika di halaman pertama
    }
  }

  void _finishAssessment() {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => ResultScreen(answers: _answers)
      )
    );
  }

  // --- 3. UI BUILDER ---

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];
    double progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FC),
        elevation: 0,
        automaticallyImplyLeading: false, // Kita buat tombol back custom di bawah
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _uiTealLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Pertanyaan ${_currentIndex + 1}/${_questions.length}",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _uiTealColor),
              ),
            ),
          ],
        ),
        // Progress Bar di AppBar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6.0),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey.shade300,
              color: _uiTealColor,
              minHeight: 6,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // JUDUL PERTANYAAN
                  Text(
                    question['question'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // AREA INPUT DINAMIS
                  _buildInputArea(question),
                ],
              ),
            ),
          ),

          // NAVIGASI BAWAH
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: Row(
              children: [
                // Tombol Kembali
                Expanded(
                  child: OutlinedButton(
                    onPressed: _prevPage,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text("Kembali", style: TextStyle(color: Colors.grey.shade700)),
                  ),
                ),
                const SizedBox(width: 16),
                // Tombol Lanjut
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _uiTealColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text("Lanjut", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // --- 4. WIDGET INPUT BUILDER (Switch Case berdasarkan Type) ---

  Widget _buildInputArea(Map<String, dynamic> question) {
    String type = question['type'];
    String id = question['id'];

    switch (type) {
      case 'yes_no':
        return Column(
          children: [
            _buildOptionCard(id, true, "Ya", Icons.check_circle_outline),
            const SizedBox(height: 16),
            _buildOptionCard(id, false, "Tidak", Icons.cancel_outlined),
          ],
        );
      
      case 'choice':
        List<String> options = question['options'];
        return Column(
          children: options.map((opt) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildTextOptionCard(id, opt),
          )).toList(),
        );

      case 'dropdown':
        List<String> items = question['options'];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: const Text("Pilih salah satu"),
              value: _answers[id],
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) {
                setState(() => _answers[id] = val);
              },
            ),
          ),
        );

      case 'number':
        return TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: question['hint'],
            suffixText: question['suffix'],
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
          ),
          onChanged: (val) {
            _answers[id] = val; // Simpan langsung saat ngetik (simple version)
          },
        );

      case 'scale':
        double currentValue = (_answers[id] as num?)?.toDouble() ?? 0.0;
        return Column(
          children: [
            Text(
              "Tingkat Nyeri: ${currentValue.toInt()}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _uiTealColor),
            ),
            const SizedBox(height: 16),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: _uiTealColor,
                inactiveTrackColor: _uiTealLight,
                thumbColor: _uiTealColor,
                overlayColor: _uiTealColor.withOpacity(0.2),
                trackHeight: 8.0,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
              ),
              child: Slider(
                value: currentValue,
                min: 0,
                max: 10,
                divisions: 10,
                label: currentValue.toInt().toString(),
                onChanged: (val) {
                  setState(() => _answers[id] = val);
                },
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tidak Sakit", style: TextStyle(color: Colors.grey)),
                Text("Sangat Sakit", style: TextStyle(color: Colors.grey)),
              ],
            )
          ],
        );

      default:
        return const Text("Tipe input tidak dikenali");
    }
  }

  // --- 5. HELPER WIDGETS ---

  // Card untuk Pilihan Ya/Tidak dengan Icon
  Widget _buildOptionCard(String id, bool value, String label, IconData icon) {
    bool isSelected = _answers[id] == value;
    return InkWell(
      onTap: () {
        setState(() => _answers[id] = value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? _uiTealColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? _uiTealColor : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: isSelected 
            ? [BoxShadow(color: _uiTealColor.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))] 
            : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            Icon(icon, color: isSelected ? Colors.white : Colors.grey, size: 28),
          ],
        ),
      ),
    );
  }

  // Card untuk Pilihan Teks (Seperti opsi Suhu)
  Widget _buildTextOptionCard(String id, String label) {
    bool isSelected = _answers[id] == label;
    return InkWell(
      onTap: () {
        setState(() => _answers[id] = label);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? _uiTealLight : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _uiTealColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? _uiTealColor : Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? _uiTealColor : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}