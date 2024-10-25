import 'package:flutter/material.dart';
import 'package:sanayi_turbo/interface/pages/product_detail_page.dart';
import 'package:sanayi_turbo/model/entity/products.dart';
import 'package:sanayi_turbo/model/enums/cetagories.dart';
import 'package:sanayi_turbo/service/product_service.dart';
import 'package:sanayi_turbo/service/storage_service.dart';

class CategoryScreen extends StatefulWidget {
  final Categories category;

  const CategoryScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        backgroundColor: Colors.grey[300],
      ),
      backgroundColor: Colors.grey[200],
      body: FutureBuilder(
        future: ProductService()
            .getProductSpecificCategory(enumToString(widget.category)),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 8.0, // Spacing between columns
                  mainAxisSpacing: 8.0, // Spacing between rows
                  childAspectRatio: 0.75, // Adjust as needed
                ),
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  Product current = snapshot.data![index];

                  return Card(
                    elevation: 3.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: FutureBuilder(
                            future: StorageService()
                                .getImage(imageId: current.imageId),
                            builder: (context, imageSnapshot) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ProductDetailPage(product: current),
                                    ),
                                  );
                                },
                                child: imageSnapshot.hasData
                                    ? Image.memory(
                                        imageSnapshot.data!,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        color: Colors.black54,
                                        width: double.infinity,
                                        height: 150.0,
                                      ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                current.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("Ücret: \$${current.price}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
