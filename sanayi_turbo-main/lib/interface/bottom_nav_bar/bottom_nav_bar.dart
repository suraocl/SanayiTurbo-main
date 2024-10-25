import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final Widget page1;
  final Widget page2;
  final Widget page3;

  const BottomNavBar({
    super.key,
    required this.page1,
    required this.page2,
    required this.page3,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.black, // Seçilen öğenin etiket rengi
        unselectedItemColor: Colors.grey, // Seçilmemiş öğenin etiket rengi
        items: [
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: "Anasayfa",
            backgroundColor: Colors.grey[400],
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.add_box_outlined,
              color: Colors.black,
            ),
            label: "Ürün Ekle",
            backgroundColor: Colors.grey[400],
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.person,
              color: Colors.black,
            ),
            label: "Profil",
            backgroundColor: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  Widget _getPage() {
    switch (_currentIndex) {
      case 0:
        return widget.page1;
      case 1:
        return widget.page2;
      case 2:
        return widget.page3;
      default:
        return Container(); // Hata durumunda boş bir widget döndürülebilir.
    }
  }
}
