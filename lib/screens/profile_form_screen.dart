import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Wajib import ini untuk inputFormatters
import '../core/app_theme.dart';
import 'question_screen.dart';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key});

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  // --- 1. CONTROLLERS & STATE ---
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String? _selectedGender;

  // BMI State
  double? _bmiValue;
  String _bmiCategory = "";
  Color _bmiColor = Colors.grey;

  // Disease State
  final List<String> _diseaseOptions = ['Asma', 'Diabetes', 'Hipertensi', 'Penyakit Jantung', 'Gangguan Ginjal', 'Tidak Ada'];
  List<String> _selectedDiseases = [];

  // Warna Teal Konsisten (Bisa juga ambil dari AppColors.primary)
  final Color _uiTealColor = const Color(0xFF4DB6AC); 
  final Color _uiTealLight = const Color(0xFFE0F2F1); 

  @override
  void initState() {
    super.initState();
    _heightController.addListener(_updateBMI);
    _weightController.addListener(_updateBMI);
  }

  @override
  void dispose() {
    _heightController.removeListener(_updateBMI);
    _weightController.removeListener(_updateBMI);
    _heightController.dispose();
    _weightController.dispose();
    _nameController.dispose(); // Good practice to dispose all controllers
    _ageController.dispose();
    super.dispose();
  }

  // --- 2. LOGIC FUNCTIONS ---
  void _updateBMI() {
    double? heightCm = double.tryParse(_heightController.text);
    double? weightKg = double.tryParse(_weightController.text);

    if (heightCm != null && weightKg != null && heightCm > 0) {
      double heightM = heightCm / 100;
      double bmi = weightKg / (heightM * heightM);

      setState(() {
        _bmiValue = bmi;
        if (bmi < 18.5) {
          _bmiCategory = "Kekurangan Berat";
          _bmiColor = AppColors.bmiWarning;
        } else if (bmi < 24.9) {
          _bmiCategory = "Normal";
          _bmiColor = AppColors.bmiNormal; // Assuming AppColors has this
        } else if (bmi < 29.9) {
          _bmiCategory = "Kelebihan Berat";
          _bmiColor = AppColors.bmiWarning;
        } else {
          _bmiCategory = "Obesitas";
          _bmiColor = AppColors.bmiDanger;
        }
      });
    } else {
      setState(() {
        _bmiValue = null;
        _bmiCategory = "";
      });
    }
  }

  void _onDiseaseSelected(String label, bool selected) {
    setState(() {
      if (selected) {
        if (label == 'Tidak Ada') {
          _selectedDiseases.clear();
          _selectedDiseases.add(label);
        } else {
          _selectedDiseases.remove('Tidak Ada');
          _selectedDiseases.add(label);
        }
      } else {
        _selectedDiseases.remove(label);
      }
    });
  }

  void _submit() {
    // Validasi Kelengkapan Data
    if (_nameController.text.isEmpty || _ageController.text.isEmpty || _bmiValue == null || _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mohon lengkapi semua data dengan benar"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Validasi Tambahan (Double Check)
    if (RegExp(r'[0-9]').hasMatch(_nameController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama tidak boleh mengandung angka"), backgroundColor: Colors.redAccent),
      );
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => const QuestionScreen()));
  }

  // --- 3. UI BUILDER ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Data Diri", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: 18)),
            Text("Lengkapi profil kesehatan Anda", style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.normal)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // CARD 1: INFORMASI PRIBADI
                  _buildSectionCard(
                    title: "Informasi Pribadi",
                    icon: Icons.person_outline,
                    children: [
                      _buildLabel("Nama Lengkap"),
                      TextField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')), 
                        ],
                        decoration: const InputDecoration(hintText: "Masukkan nama Anda"),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Umur"),
                                TextField(
                                  controller: _ageController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(2),
                                  ],
                                  decoration: const InputDecoration(hintText: "Tahun"),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Jenis Kelamin"),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: AppColors.border),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: _selectedGender,
                                      hint: const Text("Pilih"),
                                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                      borderRadius: BorderRadius.circular(16),
                                      dropdownColor: Colors.white,
                                      elevation: 4,
                                      items: ['Laki-laki', 'Perempuan'].map((val) {
                                        final isSelected = _selectedGender == val;
                                        return DropdownMenuItem<String>(
                                          value: val,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: isSelected ? _uiTealLight : Colors.transparent,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                            child: Row(
                                              children: [
                                                if (isSelected) 
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0),
                                                    child: Icon(Icons.check_rounded, color: _uiTealColor, size: 18),
                                                  ),
                                                // Fixed: Wrapped in Flexible to prevent overflow
                                                Flexible(
                                                  child: Text(
                                                    val, 
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: isSelected ? _uiTealColor : AppColors.textPrimary,
                                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (val) => setState(() => _selectedGender = val),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // CARD 2: UKURAN TUBUH
                  _buildSectionCard(
                    title: "Ukuran Tubuh",
                    icon: Icons.accessibility_new_rounded,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            _buildLabel("Tinggi Badan (cm)"), 
                            TextField(
                              controller: _heightController, 
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              decoration: const InputDecoration(hintText: "170")
                            )
                          ])),
                          const SizedBox(width: 16),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            _buildLabel("Berat Badan (kg)"), 
                            TextField(
                              controller: _weightController, 
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              decoration: const InputDecoration(hintText: "65")
                            )
                          ])),
                        ],
                      ),
                      if (_bmiValue != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: _bmiColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: _bmiColor, size: 20),
                              const SizedBox(width: 8),
                              Text("BMI: ${_bmiValue!.toStringAsFixed(1)} ($_bmiCategory)", style: TextStyle(color: _bmiColor, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ]
                    ],
                  ),

                  const SizedBox(height: 20),

                  // CARD 3: RIWAYAT PENYAKIT
                  _buildSectionCard(
                    title: "Riwayat Penyakit",
                    icon: Icons.medical_services_outlined,
                    children: [
                      Text("Pilih kondisi yang relevan:", style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 10,
                        children: _diseaseOptions.map((option) {
                          final isSelected = _selectedDiseases.contains(option);
                          return FilterChip(
                            label: Text(option),
                            selected: isSelected,
                            onSelected: (val) => _onDiseaseSelected(option, val),
                            selectedColor: _uiTealColor.withOpacity(0.15),
                            checkmarkColor: _uiTealColor,
                            backgroundColor: Colors.white,
                            labelStyle: TextStyle(
                              color: isSelected ? _uiTealColor : Colors.grey.shade700,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: isSelected ? _uiTealColor : Colors.grey.shade300),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80), 
                ],
              ),
            ),
          ),

          // --- FIXED BOTTOM BUTTON ---
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _uiTealColor, 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Lanjutkan Pemeriksaan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- 4. HELPER WIDGETS ---
  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: _uiTealColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: _uiTealColor, size: 22),
              ),
              const SizedBox(width: 16),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
    );
  }
}