# 🍏 Health Scan Products

Aplikasi mobile Flutter untuk melakukan pemindaian (scanning) produk makanan, minuman, dan kesehatan, menganalisis komposisi nutrisi serta bahan berbahaya/alergen, dan melacak riwayat kesehatan pengguna secara visual & offline.

---

## 🛠️ Tech Stack & Dependencies

- **Framework**: [Flutter](https://flutter.dev/) (SDK ^3.13.5+)
- **State Management & DI**: [Riverpod (`flutter_riverpod`)](https://riverpod.dev/) — digunakan sebagai State Management sekaligus Dependency Injection container tanpa perlu GetIt.
- **Routing**: [GoRouter (`go_router`)](https://pub.dev/packages/go_router) — deklaratif routing dengan ShellRoute untuk bottom navigation & auth guard.
- **Networking**: [Dio](https://pub.dev/packages/dio) — HTTP client dengan interceptor JWT token, auto-refresh token, dan standard error handling.
- **Local Database (Offline-First)**: [Drift](https://drift.simonbinder.eu/) (`drift`, `drift_flutter`, `sqlite3_flutter_libs`) — ORM SQLite untuk menyimpan riwayat scan dan data offline.
- **Storage**: [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage) (token & kredensial) & [Shared Preferences](https://pub.dev/packages/shared_preferences) (pengaturan lokal).
- **Authentication**: Email/Password API & [Google Sign In](https://pub.dev/packages/google_sign_in).
- **Visualisasi & Charts**: [FL Chart](https://pub.dev/packages/fl_chart) (tren nutrisi) & [Arc Gauge](https://pub.dev/packages/arc_gauge) / [Percent Indicator](https://pub.dev/packages/percent_indicator) (skor kesehatan produk).
- **Media & Kamera**: [Image Picker](https://pub.dev/packages/image_picker) & [Flutter Image Compress](https://pub.dev/packages/flutter_image_compress).
- **Form & Kalender**: [Flutter Form Builder](https://pub.dev/packages/flutter_form_builder) & [Table Calendar](https://pub.dev/packages/table_calendar).

---

## 📂 Struktur Direktori (Feature-First Architecture)

Project ini menerapkan arsitektur **Feature-First (Modular Clean Architecture)**:

```text
lib/
├── assets/                          # Static assets (images, icons, ilustrasi)
├── core/                            # Infrastruktur global & modul reusable
│   ├── common_widgets/              # Widget reusable (custom button, gauge, dialog)
│   ├── constants/                   # Konstanta kredensial & aplikasi
│   │   ├── credentials.dart         # Base URL, API headers, keys (Tanpa .env)
│   │   ├── app_constants.dart       # Dimensi, durasi, batasan sistem
│   │   └── storage_keys.dart        # Key nama untuk local storage
│   ├── database/                    # Drift SQLite database & table definitions
│   │   ├── app_database.dart
│   │   └── database_provider.dart   # Riverpod Provider untuk akses DB
│   ├── error/                       # Abstraksi Failures & Exceptions
│   ├── network/                     # Dio HTTP client, interceptors, & providers
│   │   ├── dio_client.dart
│   │   └── network_provider.dart
│   ├── routing/                     # GoRouter konfigurasi & layouts
│   │   ├── app_router.dart
│   │   └── main_layout.dart
│   ├── theme/                       # Design system, palet warna, & tema M3
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   └── utils/                       # Utility helpers (formatters, image compression)
│
├── features/                        # Modul fitur mandiri (Feature-First)
│   ├── auth/                        # Login, Register, Google Sign-In
│   │   ├── data/                    # Data sources, Models/DTOs, Repositories
│   │   └── presentation/            # Riverpod Controllers, Pages, Widgets
│   ├── scanner/                     # Scan Kamera / Image Upload / OCR Analisis
│   │   ├── data/
│   │   └── presentation/
│   ├── product_detail/              # Informasi Nutrisi, Alergen, Health Grade Score
│   │   ├── data/
│   │   └── presentation/
│   ├── history/                     # Riwayat Scan (Tersimpan di Drift DB)
│   │   ├── data/
│   │   └── presentation/
│   ├── analytics/                   # Grafik Konsumsi, Kalori & Nutrisi (FL Chart)
│   │   ├── data/
│   │   └── presentation/
│   └── profile/                     # Profil Pengguna, Alergi & Preferensi Diet
│       ├── data/
│       └── presentation/
│
└── main.dart                        # Entry point aplikasi (ProviderScope & App Runner)
```

---

## 📐 Konvensi Coding & Arsitektur

### 1. Root Package Imports
Seluruh impor file internal **wajib** menggunakan package import root (`package:health_scan_products/...`), hindari penggunaan relative path (`../../`):
```dart
// ✅ BENAR
import 'package:health_scan_products/core/constants/credentials.dart';
import 'package:health_scan_products/features/scanner/data/models/scan_result_model.dart';

// ❌ HINDARI
import '../../core/constants/credentials.dart';
```

### 2. Kredensial & Konfigurasi API (Tanpa `.env`)
Project ini **tidak menggunakan file `.env`**. Seluruh konfigurasi endpoint dan koneksi server dikelola secara terpusat di:
👉 `lib/core/constants/credentials.dart`

```dart
class Credentials {
  // Ganti baseUrl sesuai environment backend kamu:
  // - Android Emulator : http://10.0.2.2:8000/api/v1
  // - Real Device / LAN: http://<IP_KOMPUTER_KAMU>:8000/api/v1
  // - Production / Staging: https://api.yourdomain.com/api/v1
  static const String baseUrl = 'https://api.yourhealthscan.com/api/v1';
}
```

### 3. Dependency Injection dengan Riverpod
Tidak memerlukan library DI tambahan seperti `GetIt` atau `@injectable`. Semua dependency (Dio, Secure Storage, Database, Data Source, Repository) di-*provide* langsung menggunakan Riverpod:
```dart
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(secureStorageProvider),
  );
});
```

---

## 🚀 Cara Menjalankan Project

### 1. Clone & Masuk ke Direktori
```bash
git clone <URL_REPOSITORY>
cd health_scan_products
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Konfigurasi Backend URL
Buka `lib/core/constants/credentials.dart` dan sesuaikan nilai `baseUrl` dengan alamat server backend kamu.

### 4. Build Runner (Jika Menggunakan Code Generation Drift/JSON)
Jika ada perubahan tabel Drift atau model serialization:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 5. Jalankan Aplikasi
```bash
# Debug mode di device atau emulator yang aktif
flutter run
```

---

## 👥 Kontribusi & Panduan Git
1. Buat branch baru untuk setiap fitur: `git checkout -b feature/nama-fitur`.
2. Pastikan tidak ada warning atau error linting: `flutter analyze`.
3. Gunakan commit message yang deskriptif (misal: `feat(scanner): add image compression before upload`).
