import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sanayi_turbo/model/entity/products.dart';

class ProductService {
  final _auth = FirebaseAuth.instance;
  var productRef = FirebaseFirestore.instance.collection("Product");

  Future<bool> addProduct(Product productModel) async {
    try {
      await productRef.doc(productModel.id).set(productModel.toJson());
      return true;
    } on FirebaseException {
      return false;
    }
  }

  Future<List<Product>?> getProducts() async {
    try {
      List<Product> temp = [];
      var data = await productRef.get();
      for (var element in data.docs) {
        temp.add(Product.fromJson(element.data()));
      }
      return temp;
    } catch (e) {
      return null;
    }
  }

  Future<List<Product>?> getProductSpecificCategory(String category) async {
    try {
      List<Product> temp = [];
      var data =
          await productRef.where("categories", isEqualTo: category).get();

      for (var element in data.docs) {
        temp.add(Product.fromJson(element.data()));
      }
      return temp;
    } catch (e) {
      return null;
    }
  }

  Future<List<Product>?> getMyProduct() async {
    try {
      List<Product> temp = [];
      var data = await productRef
          .where("ownerMail", isEqualTo: _auth.currentUser!.email!)
          .get();

      for (var element in data.docs) {
        temp.add(Product.fromJson(element.data()));
      }
      return temp;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      await productRef.doc(productId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Product>?> getSearchProducts(String searchQuery) async {
    try {
      List<Product> temp = [];
      var data = await productRef.get();

      for (var element in data.docs) {
        var product = Product.fromJson(element.data());
        // Check if the product name contains the search query
        if (product.name.toLowerCase().contains(searchQuery.toLowerCase())) {
          temp.add(product);
        }
      }
      return temp;
    } catch (e) {
      return null;
    }
  }
}
