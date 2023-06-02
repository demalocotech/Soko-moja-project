import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  Map<String, dynamic> productData = {};

  //Save data to provider

  getFormData({
    String? productName,
    double? productPrice,
    int? quantity,
    String? category,
    String? productDescription,
    List<String>? imageUrls,
  }) {
    if (productName != null) {
      productData['productName'] = productName;
    }
    if (productPrice != null) {
      productData['productPrice'] = productPrice;
    }
    if (quantity != null) {
      productData['quantity'] = quantity;
    }
    if (category != null) {
      productData['category'] = category;
    }
    if (productDescription != null) {
      productData['productDescription'] = productDescription;
    }
    if (imageUrls != null) {
      productData['imageUrls'] = imageUrls;
    }
  }
}
