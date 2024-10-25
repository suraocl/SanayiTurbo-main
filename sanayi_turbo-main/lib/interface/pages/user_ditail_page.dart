import 'package:flutter/material.dart';
import 'package:sanayi_turbo/interface/screens/login_screen.dart';
import 'package:sanayi_turbo/interface/screens/my_product_screen.dart';

class UserDitailPage extends StatefulWidget {
  const UserDitailPage({super.key});

  @override
  State<UserDitailPage> createState() => _UserDitailPageState();
}

class _UserDitailPageState extends State<UserDitailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.grey[300],
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'İşlemler',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListTile(
              title: const Text('Yüklenmiş Ürünlerim'),
              leading: const Icon(Icons.shopping_bag),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MyProductScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Gelen İstekler'),
              leading: const Icon(Icons.paid_outlined),
              onTap: () {
                //istek sayfasi
              },
            ),
            const Divider(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              child: const Text('Çıkış Yap'),
            ),
          ],
        ),
      ),
    );
  }
}
