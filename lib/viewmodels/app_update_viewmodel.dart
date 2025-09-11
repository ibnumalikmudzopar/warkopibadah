import 'package:flutter/material.dart';
import '../services/app_update_service.dart';

class AppUpdateViewModel with ChangeNotifier {
  final AppUpdateService _appUpdateService = AppUpdateService();

  String? _updateUrl;
  bool get isUpdateAvailable => _updateUrl != null;


  Future<void> checkUpdate() async {
    _updateUrl = await _appUpdateService.checkForUpdate();
    if (_updateUrl != null) {
      notifyListeners();
    }
  }

  void showUpdateDialog(BuildContext context) {
    if (isUpdateAvailable && _updateUrl != null) {
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
                  _appUpdateService.launchUpdateUrl(_updateUrl!);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}