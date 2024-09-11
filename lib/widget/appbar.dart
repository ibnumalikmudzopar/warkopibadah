import 'package:flutter/material.dart'; // Import library flutter/material untuk pengembangan UI

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MyAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title), // Menampilkan judul AppBar sesuai dengan properti title
      actions: [
        IconButton(
          onPressed: () {
            // Tambahkan fungsi yang sesuai untuk menu
          },
          icon: const Icon(Icons.menu), // Menambahkan icon menu
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Mendapatkan ukuran preferensi AppBar
}