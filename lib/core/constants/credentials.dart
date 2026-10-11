class Credentials {
  Credentials._();

  // Base URL API Backend (sesuaikan dengan environment/IP server)
  // Gunakan 'http://10.0.2.2:8000/api/v1' jika menggunakan Android Emulator
  static const String baseUrl = 'https://api.yourhealthscan.com/api/v1';

  // Timeout konfigurasi
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Header dasar tanpa otentikasi (Auth, Public Endpoints)
  static Map<String, String> get baseHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Header dengan token otentikasi (Bearer Token)
  static Map<String, String> authenticatedHeaders(String token) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  // Storage Keys untuk Secure Storage
  static const String keyJwtToken = 'jwt_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
}
