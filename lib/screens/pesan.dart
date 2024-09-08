import 'package:flutter/material.dart';

class PesanScreen extends StatefulWidget {
  @override
  _PesanScreenState createState() => _PesanScreenState();
}

class _PesanScreenState extends State<PesanScreen> {
  bool isViewingAllMessages = false;

  void toggleView() {
    setState(() {
      isViewingAllMessages = !isViewingAllMessages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isViewingAllMessages ? buildSemuaPesanScreen() : buildMainPesanScreen();
  }

  Widget buildMainPesanScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Kotak Update
          GestureDetector(
            onTap: toggleView, // Ganti tampilan ke Semua Pesan
            child: Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Update',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: toggleView, // Ganti tampilan ke Semua Pesan
            child: Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Update',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),

          // Kotak Diskusi
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Diskusi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: TextField(
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Tulis pesan...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Logika pengiriman pesan
                        // Misalnya, memanggil fungsi untuk menyimpan pesan ke Firestore
                      },
                      icon: Icon(Icons.send),
                      label: Text('Kirim'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSemuaPesanScreen() {
    return Scaffold(
      appBar: AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: toggleView, // Go back to main pesan screen
      ),
      title: Text('Semua Pesan'),
    ),
      body: ListView.builder(
        itemCount: 20, // Ganti dengan jumlah pesan yang kamu ambil dari Firestore
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Pesan ${index + 1}'),
            subtitle: Text('Detail dari pesan ${index + 1}'),
          );
        },
      ),
    );
  }
}
