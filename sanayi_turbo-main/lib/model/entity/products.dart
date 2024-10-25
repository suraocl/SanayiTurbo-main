import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sanayi_turbo/model/enums/cetagories.dart';
import 'package:sanayi_turbo/service/push_notification_helper.dart';

class Product {
  static final _auth = FirebaseAuth.instance;
  static final _notif = PushNotificationHelper.fcmToken;
  final String id;
  final String name;
  final String price;
  final String description;
  final String imageId;
  final String ownerMail;
  final String ownerToken;
  Categories categories;

  Product(
      {required this.ownerMail,
      required this.ownerToken,
      required this.id,
      required this.categories,
      required this.name,
      required this.price,
      required this.description,
      required this.imageId});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["name"] = name;
    json["price"] = price;
    json["description"] = description;
    json["imageId"] = imageId;
    json["categories"] = enumToString(categories);
    json["ownerMail"] = ownerMail;
    json["ownerToken"] = ownerToken;

    return json;
  }

  static Product createProduct({
    required String name,
    required String price,
    required String description,
    required String imageId,
    required Categories categories,
  }) {
    var productRef = FirebaseFirestore.instance.collection("Product").doc();
    return Product(
        ownerMail: _auth.currentUser!.email!,
        ownerToken: _notif,
        id: productRef.id,
        categories: categories,
        name: name,
        price: price,
        description: description,
        imageId: imageId);
  }

  static fromJson(Map json) {
    return Product(
        ownerMail: json["ownerMail"],
        ownerToken: json["ownerToken"],
        id: json["id"],
        categories: stringToEnum(json["categories"]),
        name: json["name"],
        price: json["price"],
        description: json["description"],
        imageId: json["imageId"]);
  }

  double toDouble(var value) {
    if (value.runtimeType == double) {
      return value;
    } else {
      return double.parse(value.toString());
    }
  }
}
