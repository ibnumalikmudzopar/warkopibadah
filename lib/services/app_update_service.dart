// File: lib/services/app_update_service.dart

import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  // 1. Tambahkan metode initialize() di sini
  Future<void> initialize() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1), // Mengubah menjadi 1 jam untuk efisiensi
      ));
      await _remoteConfig.fetchAndActivate();
      debugPrint('Firebase Remote Config berhasil diinisialisasi.');
    } catch (e) {
      debugPrint("Gagal mengambil konfigurasi remote: $e");
    }
  }

  // 2. Perbarui metode checkForUpdate
  // Sekarang hanya perlu membaca nilai, karena sudah di-fetch di initialize()
  Future<String?> checkForUpdate() async {
    try {
      final String latestVersion = _remoteConfig.getString('latest_app_version');
      final String downloadUrl = _remoteConfig.getString('download_url');
      
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      debugPrint("Versi saat ini: $currentVersion");
      debugPrint("Versi terbaru di Firebase: $latestVersion");

      if (latestVersion.isNotEmpty && latestVersion != currentVersion) {
        return downloadUrl;
      }
    } catch (e) {
      debugPrint("Gagal memeriksa pembaruan: $e");
    }
    return null;
  }

  // Meluncurkan URL unduhan APK
  Future<void> launchUpdateUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      debugPrint("Tidak dapat membuka URL pembaruan");
    }
  }
}