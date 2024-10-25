// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sanayi_turbo/model/entity/products.dart';
import 'package:sanayi_turbo/model/enums/cetagories.dart';
import 'package:sanayi_turbo/service/product_service.dart';
import 'package:sanayi_turbo/service/storage_service.dart';
import 'package:uuid/uuid.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();
  String? _imagePath;
  late String productName;
  late String productPrice;
  late String productDescription;
  Categories selectedCategory = Categories.car;
  Uint8List? selectedImage;

  Future<Uint8List?> getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 25);
    if (pickedFile != null) {
      return await pickedFile.readAsBytes();
    }
    return null;
  }

  Future<Uint8List?> _getImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      List<int> imageBytes = await File(pickedFile.path).readAsBytes();
      return Uint8List.fromList(imageBytes);
    }

    return null;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Urun Ekle'),
        backgroundColor: Colors.grey[300],
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  productName = value;
                },
                controller: _productNameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (value) {
                  productPrice = value;
                },
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (value) {
                  productDescription = value;
                },
                controller: _productDescriptionController,
                decoration:
                    const InputDecoration(labelText: 'Product Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  CategoryDropdown(
                    selectedCategory: selectedCategory,
                    callBack: (val) {
                      setState(() {
                        selectedCategory = val;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          selectedImage = await getImageFromGallery();
                        },
                        child:
                            const Icon(Icons.photo_size_select_actual_rounded),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          selectedImage = await _getImageFromCamera();
                        },
                        child: const Icon(Icons.camera),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          print("basıldı");
                          try {
                            print("deniyorum");

                            String imageId = const Uuid().v4();
                            if (selectedImage != null) {
                              bool response = await StorageService().addImage(
                                  image: selectedImage!, imageId: imageId);
                              print("response");
                              print(response);

                              if (response) {
                                var newProduct = Product.createProduct(
                                  categories: selectedCategory,
                                  name: _productNameController.text,
                                  price: _priceController.text,
                                  description:
                                      _productDescriptionController.text,
                                  imageId: imageId,
                                );

                                var databaseResponse = await ProductService()
                                    .addProduct(newProduct);
                                if (databaseResponse) {
                                  print("ekleme başarılı");
                                } else {
                                  print("ekleme başarılı değil ");
                                }
                              } else {
                                print("storage  başarılı değil ");
                              }
                            } else {
                              print("image null");
                            }
                          } catch (e) {
                            print("erorrrrr");
                            print(e);
                          }
                        },
                        child: const Icon(Icons.save_alt_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _imagePath != null
                      ? Image.file(
                          File(_imagePath!),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )
                      : Container(),
                  const SizedBox(height: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryDropdown extends StatefulWidget {
  Categories selectedCategory;
  final Function(Categories val) callBack;
  CategoryDropdown(
      {super.key, required this.selectedCategory, required this.callBack});

  @override
  _CategoryDropdownState createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Categories>(
      value: widget.selectedCategory,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.blue,
      ),
      onChanged: (Categories? newValue) {
        setState(() {
          if (newValue != null) {
            // Update the selected category in the parent widget
            widget.callBack(newValue);
          }
        });
      },
      items: Categories.values
          .map<DropdownMenuItem<Categories>>((Categories value) {
        return DropdownMenuItem<Categories>(
          value: value,
          child: Text(value.name),
        );
      }).toList(),
    );
  }
}
