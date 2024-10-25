import 'package:flutter/material.dart';
import 'package:sanayi_turbo/model/entity/products.dart';
import 'package:sanayi_turbo/service/product_service.dart';
import 'package:sanayi_turbo/service/storage_service.dart';

class MyProductScreen extends StatefulWidget {
  const MyProductScreen({super.key});

  @override
  State<MyProductScreen> createState() => _MyProductScreenState();
}

class _MyProductScreenState extends State<MyProductScreen> {
  Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text("Ürünü Sil"),
              content: Text("Silmek istediğinizden emin misiniz?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext)
                        .pop(false); // User canceled deletion
                  },
                  child: Text("Çık"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext)
                        .pop(true); // User confirmed deletion
                  },
                  child: Text("Sil"),
                ),
              ],
            );
          },
        ) ??
        false; // If the dialog is dismissed, consider it as canceling deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Urunlerim"),
        backgroundColor: Colors.grey[300],
      ),
      backgroundColor: Colors.grey[200],
      body: FutureBuilder(
        future: ProductService().getMyProduct(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.75,
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
                                onTap: () async {
                                  bool deleteConfirmed =
                                      await showDeleteConfirmationDialog(
                                          context);
                                  if (deleteConfirmed) {
                                    bool deleted = await ProductService()
                                        .deleteProduct(current.id);
                                    if (deleted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "${current.name} deleted successfully."),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Failed to delete ${current.name}."),
                                        ),
                                      );
                                    }
                                  }
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
