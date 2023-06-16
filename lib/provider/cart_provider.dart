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

  double get totalPrice {
    var total = 0.0;
    _cartItems.forEach((key, value) {
      total += value.productPrice * value.quantity;
    });
    return total;
  }

//FUNCTION TO ADD PRODUCT TO CART
  void addProductToCart(
    String productName,
    String productId,
    List imageUrl,
    int quantity,
    int productQuantity,
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
                productQuantity: existingCart.productQuantity,
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
              productQuantity: productQuantity,
              productPrice: productPrice,
              userId: userId,
              productSize: productSize));

      notifyListeners();
    }
  }

  void increment(CartAttr cartAttr) {
    cartAttr.increase();

    notifyListeners();
  }

  void decrement(CartAttr cartAttr) {
    cartAttr.decrease();
    notifyListeners();
  }

  removeItem(productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  removeAllItems() {
    _cartItems.clear();
    notifyListeners();
  }
}
