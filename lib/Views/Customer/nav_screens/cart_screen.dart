import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: _cartProvider.getCartItem.length,
        itemBuilder: (BuildContext context, int index) {
          final cartData = _cartProvider.getCartItem.values.toList()[index];

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
                        Container(
                          height: 40,
                          width: 110,
                          decoration: BoxDecoration(
                            color: Colors.lightGreen.shade900,
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {},
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
                                onPressed: () {},
                                icon: Icon(
                                  CupertinoIcons.plus,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text(
      //         'Your cart is empty',
      //         style: TextStyle(
      //           fontSize: 22,
      //           fontWeight: FontWeight.bold,
      //           letterSpacing: 5,
      //         ),
      //       ),
      //       SizedBox(
      //         height: 20,
      //       ),
      //       Container(
      //         height: 40,
      //         width: MediaQuery.of(context).size.width - 40,
      //         decoration: BoxDecoration(
      //           color: Colors.lightGreen.shade900,
      //           borderRadius: BorderRadius.circular(10),
      //         ),
      //         child: Center(
      //           child: Text(
      //             'continue shopping',
      //             style: TextStyle(
      //               fontSize: 19,
      //               color: Colors.white,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
