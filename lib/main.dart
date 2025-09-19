import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:warkopibadah/firebase_options.dart';
import 'viewmodels/harga_jual_barang_viewmodel.dart';
import 'viewmodels/belanja_viewmodel.dart';
import 'viewmodels/calculator_viewmodel.dart';
import 'viewmodels/harga_beli_barang_viewmodel.dart';
import 'viewmodels/widget_tree.dart';
import 'repositories/harga_jual_barang_repository.dart';
import 'repositories/harga_beli_barang_repository.dart';
import 'repositories/belanja_repository.dart';
import 'services/app_update_service.dart'; // Import service
import 'viewmodels/app_update_viewmodel.dart'; // Import viewmodel

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final appUpdateService = AppUpdateService();
  await appUpdateService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HargaJualBarangViewModel(
            repository: HargaJualBarangRepository(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => HargaBeliBarangViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => BelanjaViewModel(),
        ),
        ChangeNotifierProvider(create: (_) => CalculatorViewModel()),
        ChangeNotifierProvider(
          create: (_) => AppUpdateViewModel(appUpdateService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Manajemen WarungKopi Ibadah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.5,
        ),
      ),
      home: const MainAppScreen(),
    );
  }
}

class MainAppScreen extends StatelessWidget {
  const MainAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Panggil metode tunggal yang menangani pemeriksaan dan dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppUpdateViewModel>(context, listen: false)
          .checkAndUpdate(context);
    });

    return const WidgetTree();
  }
}