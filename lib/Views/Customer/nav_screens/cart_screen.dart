import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sokomoja_project/Views/Customer/inner_screens/checkout_screen.dart';
import 'package:sokomoja_project/provider/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen.shade900,
        elevation: 0,
        title: Text(
          'Cart Screen',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _cartProvider.removeAllItems();
            },
            icon: Icon(
              CupertinoIcons.delete,
            ),
          ),
        ],
      ),
      body: _cartProvider.getCartItem.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: _cartProvider.getCartItem.length,
              itemBuilder: (BuildContext context, int index) {
                final cartData =
                    _cartProvider.getCartItem.values.toList()[index];

                return Card(
                  child: SizedBox(
                    height: 170,
                    child: Row(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.network(cartData.imageUrl[0]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartData.productName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 5,
                                ),
                              ),
                              Text(
                                'KSH' +
                                    ' ' +
                                    cartData.productPrice.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 5,
                                  color: Colors.lightGreen.shade900,
                                ),
                              ),
                              OutlinedButton(
                                onPressed: null,
                                child: Text(
                                  cartData.productSize,
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 115,
                                    decoration: BoxDecoration(
                                      color: Colors.lightGreen.shade900,
                                    ),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: cartData.quantity == 1
                                              ? null
                                              : () {
                                                  _cartProvider
                                                      .decrement(cartData);
                                                },
                                          icon: Icon(
                                            CupertinoIcons.minus,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          cartData.quantity.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: cartData.productQuantity ==
                                                  cartData.quantity
                                              ? null
                                              : () {
                                                  _cartProvider
                                                      .increment(cartData);
                                                },
                                          icon: Icon(
                                            CupertinoIcons.plus,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _cartProvider
                                          .removeItem(cartData.productId);
                                    },
                                    icon: Icon(
                                      CupertinoIcons.cart_badge_minus,
                                      color: Colors.lightGreen.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                      color: Colors.lightGreen.shade900,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'continue shopping',
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: _cartProvider.totalPrice == 0.00
              ? null
              : () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CheckOutScreen();
                  }));
                },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: _cartProvider.totalPrice == 0.00
                  ? Colors.lightGreen
                  : Colors.lightGreen.shade900,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "KSH" +
                    " " +
                    _cartProvider.totalPrice.toStringAsFixed(2) +
                    " " +
                    'CHECKOUT',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 5,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
