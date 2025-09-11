// File: lib/services/app_update_service.dart

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  // Metode untuk memeriksa pembaruan secara asinkron
  Future<String?> checkForUpdate() async {
    try {
      // Fetch dan aktifkan konfigurasi terbaru sebelum membaca nilainya
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));
      await _remoteConfig.fetchAndActivate();

      final String latestVersion = _remoteConfig.getString('latest_app_version');
      final String downloadUrl = _remoteConfig.getString('download_url');

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      // Periksa apakah versi terbaru tidak kosong dan berbeda dari versi saat ini
      if (latestVersion.isNotEmpty && latestVersion != currentVersion) {
        return downloadUrl;
      }
    } catch (e) {
      // Menangani kesalahan jika gagal mengambil atau membandingkan versi
      print('Gagal memeriksa pembaruan: $e');
    }
    return null; // Tidak ada pembaruan atau terjadi kesalahan
  }

  // Meluncurkan URL unduhan APK
  Future<void> launchUpdateUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}