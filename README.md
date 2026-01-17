# 🏥 Health Check App

[![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-blue?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0%2B-blue?logo=dart)](https://dart.dev)
[![Vercel](https://img.shields.io/badge/Deploy-Vercel-black?logo=vercel)](https://vercel.com)

**Health Check** adalah aplikasi pemantauan kesehatan mandiri (*self-assessment*) yang dirancang untuk membantu pengguna melakukan pengecekan kondisi tubuh awal secara cepat dan mudah. Aplikasi ini menyediakan fitur kalkulator kesehatan dan pencatatan gejala ringan untuk memberikan rekomendasi gaya hidup sehat.

---

## 🚀 Live Demo
Coba aplikasi langsung melalui browser tanpa perlu instalasi:

👉 **[Klik Disini untuk Membuka Aplikasi (Vercel)](https://health-scan-web.vercel.app)**

---

## ✨ Fitur Utama
* **🩺 Symptom Checker:** Input gejala kesehatan yang dirasakan dan dapatkan analisis awal serta saran penanganan mandiri.
* **⚖️ BMI Calculator:** Hitung Indeks Massa Tubuh (*Body Mass Index*) secara akurat untuk mengetahui status berat badan ideal.
* **📱 Multi-Platform:** Dibangun dengan Flutter, aplikasi ini responsif dan berjalan lancar di **Android**, **iOS**, dan **Web**.
* **🔒 Privasi Terjamin:** Semua pemrosesan data dilakukan di sisi klien (*Client-Side Logic*), sehingga data kesehatan pengguna tetap aman.

## 🛠️ Teknologi yang Digunakan
* **Framework:** [Flutter](https://flutter.dev) (Dart)
* **Architecture:** Clean Architecture & MVC Pattern
* **Deployment:** Vercel (Web Hosting)
* **Version Control:** Git & GitHub

## 📂 Struktur Project
Struktur folder proyek ini disusun agar mudah dikembangkan (*scalable*):

```text
lib/
├── main.dart           # Entry point aplikasi
├── core/               # Konfigurasi dasar (Tema, Utility)
├── models/             # Model data (BMI, Gejala)
├── screens/            # Halaman UI (Home, Result, Form)
└── widgets/            # Komponen UI yang dapat digunakan ulang