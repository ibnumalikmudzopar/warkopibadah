import 'package:flutter/material.dart';
import '../services/app_update_service.dart';

class AppUpdateViewModel with ChangeNotifier {
  final AppUpdateService _appUpdateService;
  
  // Perbaiki constructor untuk menerima AppUpdateService
  AppUpdateViewModel(this._appUpdateService);

  // Metode untuk memeriksa pembaruan dan menampilkan dialog
  Future<void> checkAndUpdate(BuildContext context) async {
    final updateUrl = await _appUpdateService.checkForUpdate();
    if (updateUrl != null) {
      showUpdateDialog(context, updateUrl);
    }
  }

  void showUpdateDialog(BuildContext context, String updateUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pembaruan Tersedia'),
          content: const Text('Versi terbaru aplikasi sudah tersedia. Unduh sekarang?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Nanti'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Unduh'),
              onPressed: () {
                _appUpdateService.launchUpdateUrl(updateUrl);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}