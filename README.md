# 🏥 Health Check App - Aplikasi Pemantauan Kesehatan Mandiri

![Flutter](https://img.shields.io/badge/Flutter-3.16-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Vercel](https://img.shields.io/badge/Vercel-Deploy-000000?style=for-the-badge&logo=vercel&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Web%20|%20Android-green?style=for-the-badge)

**Health Check** adalah aplikasi berbasis *mobile* dan *web* yang dirancang untuk memudahkan pengguna melakukan pemeriksaan kondisi kesehatan awal secara mandiri (*Self-Assessment*). Aplikasi ini menggabungkan antarmuka yang intuitif dengan logika perhitungan medis standar untuk memberikan gambaran cepat mengenai status kebugaran pengguna.

Proyek ini dikembangkan sebagai bagian dari **Tugas Akhir Mata Kuliah Rekayasa Perangkat Lunak** untuk mendemonstrasikan implementasi *Pembuatan Perangkat Lunak*

---

## 🌐 Live Demo
Coba aplikasi langsung melalui browser tanpa perlu instalasi:

### 👉 [Klik Disini untuk Membuka Aplikasi (Vercel)](https://health-scan-web.vercel.app)
*(Catatan: Aplikasi dioptimalkan untuk tampilan Mobile. Gunakan Browser HP atau Mode Responsif di Desktop)*

---

## ✨ Fitur Unggulan

### 1. 🩺 Diagnosa Gejala Mandiri (Symptom Checker)
Fitur interaktif dimana pengguna dapat memilih gejala yang dirasakan. Sistem akan memproses input menggunakan algoritma logika internal untuk memberikan:
* Analisis kemungkinan kondisi kesehatan.
* Saran penanganan awal (Pertolongan Pertama).
* Rekomendasi tindakan lanjut (misal: "Segera ke dokter").

### 2. ⚖️ Kalkulator BMI (Body Mass Index)
Perhitungan berat badan ideal secara *real-time* berdasarkan input tinggi dan berat badan. Hasil mencakup:
* Nilai BMI presisi.
* Kategori berat badan (Kurus, Normal, Gemuk, Obesitas).
* Indikator visual warna (Hijau untuk sehat, Merah untuk waspada).

### 3. 🔒 Keamanan & Privasi (Client-Side Logic)
Aplikasi ini dibangun dengan arsitektur *Serverless Logic*. Seluruh pemrosesan data kesehatan dilakukan secara lokal di perangkat pengguna, sehingga data pribadi tidak disimpan di database eksternal demi menjaga privasi.

### 4. 📱 Desain Responsif (Multi-Platform)
Menggunakan kekuatan framework Flutter, satu basis kode (*Single Codebase*) berjalan mulus di:
* **Android:** Sebagai aplikasi native (APK).
* **Web:** Sebagai Progressive Web App (PWA) yang ringan.

---

## 🛠️ Teknologi & Arsitektur

* **Framework:** [Flutter SDK](https://flutter.dev)
* **Language:** Dart
* **State Management:** `setState` & `Provider` (untuk manajemen data ringan)
* **Architecture Pattern:** MVC (Model-View-Controller) / Clean Architecture
* **Deployment:** Vercel (Web Hosting)
* **Version Control:** Git & GitHub

### Struktur Folder
```text
lib/
├── core/               # Konfigurasi dasar (Tema warna, Konstanta)
├── data/               # Data statis (Daftar gejala, Logika penyakit)
├── models/             # Blueprint objek (User, Symptom)
├── screens/            # Tampilan UI (Home, Form, Result)
├── widgets/            # Komponen UI reusable (Custom Button, Card)
└── main.dart           # Titik masuk aplikasi
```

## 📦 Cara Instalasi & Menjalankan (Local Development)

Ikuti langkah berikut untuk menjalankan proyek ini di komputer lokal Anda:

### 1. Prasyarat (Prerequisites)

Pastikan Anda telah menginstal:

* [Flutter SDK](https://docs.flutter.dev/get-started/install) (Versi stabil terbaru)
* [VS Code](https://code.visualstudio.com/) atau Android Studio
* [Git](https://git-scm.com/)

### 2. Clone Repository

Unduh kode sumber ke komputer lokal:

```bash
git clone https://github.com/DvRex/Health-Scan-App.git
```

### 3. Masuk ke Folder Project

```bash
cd health-check-app
```

### 4. Install Dependencies

Unduh paket pustaka yang dibutuhkan:

```bash
flutter pub get
```

### 5. Jalankan Aplikasi (Run)

* **Mode Web (Chrome):**
```bash
flutter run -d chrome
```


* **Mode Android (Emulator/HP):**
Pastikan Emulator menyala atau HP tersambung via USB Debugging.
```bash
flutter run -d android
```



### 6. Build File APK (Opsional)

Jika ingin membuat file instalasi `.apk` untuk HP Android:

```bash
flutter build apk --release
```

*File hasil build akan berada di folder:* `build/app/outputs/flutter-apk/app-release.apk`

---

> **Disclaimer:**
> Aplikasi ini dibuat untuk tujuan pendidikan dan simulasi tugas akhir. Hasil diagnosa yang diberikan oleh sistem ini hanyalah perkiraan awal berdasarkan algoritma logika dan **tidak dapat menggantikan saran medis profesional**. Segera hubungi dokter jika Anda mengalami gejala serius.

---

<center>
<p>Copyright © 2026</p>
</center>


