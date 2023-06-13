import 'package:flutter/material.dart';

class CartAttr with ChangeNotifier {
  final String productName;

  final String productId;

  final List imageUrl;

  final int quantity;

  final double productPrice;

  final String userId;

  final String productSize;

  CartAttr({
    required this.productName,
    required this.productId,
    required this.imageUrl,
    required this.quantity,
    required this.productPrice,
    required this.userId,
    required this.productSize,
  });
}
