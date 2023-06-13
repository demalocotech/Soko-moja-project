import 'package:flutter/material.dart';
import 'package:sokomoja_project/Models/cart_attributes.dart';

//get access to products

class CartProvider with ChangeNotifier {
  // create variable to store added item
  Map<String, CartAttr> _cartItems = {};
//override cart items
  Map<String, CartAttr> get getCartItem {
    return _cartItems;
  }

//FUNCTION TO ADD PRODUCT TO CART
  void addProductToCart(
    String productName,
    String productId,
    List imageUrl,
    int quantity,
    double productPrice,
    String userId,
    String productSize,
  ) {
    //check if product exists and increment quantity by 1
    //functionality to add products to cart
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
          productId,
          (existingCart) => CartAttr(
                productName: existingCart.productName,
                productId: existingCart.productId,
                imageUrl: existingCart.imageUrl,
                quantity: existingCart.quantity + 1,
                productPrice: existingCart.productPrice,
                userId: existingCart.userId,
                productSize: existingCart.productSize,
              ));
      notifyListeners();
    } else {
      _cartItems.putIfAbsent(
          productId,
          () => CartAttr(
              productName: productName,
              productId: productId,
              imageUrl: imageUrl,
              quantity: quantity,
              productPrice: productPrice,
              userId: userId,
              productSize: productSize));

      notifyListeners();
    }
  }
}
