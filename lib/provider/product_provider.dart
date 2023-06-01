import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  Map<String, dynamic> productData = {};

  //Save data to provider

  getFormData({String? productName}) {
    if (productName != null) {
      productData['productName'] = productName;
    }
  }
}
