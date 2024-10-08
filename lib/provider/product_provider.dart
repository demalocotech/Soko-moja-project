import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  Map<String, dynamic> productData = {};

  //Save data to provider

  getFormData(
      {String? productName,
      double? productPrice,
      int? quantity,
      String? category,
      String? productDescription,
      List<String>? imageUrls,
      bool? chargeDelivery,
      int? deliveryCharge,
      String? brandName,
      List<String>? sizeList}) {
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
    if (chargeDelivery != null) {
      productData['chargeDelivery'] = chargeDelivery;
    }
    if (deliveryCharge != null) {
      productData['deliveryCharge'] = deliveryCharge;
    }
    if (brandName != null) {
      productData['brandName'] = brandName;
    }
    if (sizeList != null) {
      productData['sizeList'] = sizeList;
    }
    notifyListeners();
  }

  clearData() {
    productData.clear();
    notifyListeners();
  }
}
