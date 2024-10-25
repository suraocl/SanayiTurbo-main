import 'package:flutter/material.dart';
import 'package:sanayi_turbo/interface/pages/product_detail_page.dart';
import 'package:sanayi_turbo/interface/screens/category_screen.dart';
import 'package:sanayi_turbo/interface/screens/notifications_screen.dart';
import 'package:sanayi_turbo/model/entity/products.dart';
import 'package:sanayi_turbo/model/enums/cetagories.dart';
import 'package:sanayi_turbo/service/product_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearch = false;
  TextEditingController searchController = TextEditingController();
  List<Product>? filteredProducts;
  final ProductService _productService = ProductService();

  var categoriesImages = Categories.values;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearch
            ? TextField(
                decoration: const InputDecoration(hintText: "Ara"),
                onChanged: (value) {
                  _productService.getSearchProducts(value).then((products) {
                    setState(() {
                      filteredProducts = products;
                    });
                  });
                },
              )
            : const Text(
                "Sanayi Go",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          isSearch
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isSearch = false;
                    });
                  },
                  icon: const Icon(Icons.clear))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      isSearch = true;
                    });
                  },
                  icon: const Icon(Icons.search)),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
        ],
        backgroundColor: Colors.grey[300],
      ),
      backgroundColor: Colors.grey[200],
      body: isSearch == true
          ? ListView.builder(
              itemCount: filteredProducts?.length ?? 0,
              itemBuilder: (context, index) {
                var product = filteredProducts![index]; 
                return ListTile(
                  title: Text(product.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailPage(product: product), //Urun sayfasına git
                      ),
                    );
                  },
                );
              },
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: Categories.values.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to CategoryScreen with the selected category
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CategoryScreen(category: Categories.values[index]),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // You can replace this with an image widget
                        Image.asset(
                          'assets/images/${enumToString(Categories.values[index]).toString().toLowerCase()}.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 120,
                        ),
                        const SizedBox(height: 8),
                        Text(enumToString(Categories.values[index])),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
