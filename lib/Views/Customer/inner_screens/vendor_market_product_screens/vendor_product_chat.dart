import 'package:flutter/material.dart';
import 'package:sokomoja_project/Views/Customer/inner_screens/vendor_market_product_screens/vendor_chats.dart';
import 'package:sokomoja_project/Views/Customer/inner_screens/vendor_market_product_screens/vendor_products.dart';

class VendorProductChat extends StatelessWidget {
  final vendorData;

  const VendorProductChat({super.key, required this.vendorData});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.lightGreen.shade900,
            bottom: TabBar(tabs: [
              Tab(
                text: 'Products',
              ),
              Tab(
                text: 'Chat',
              ),
            ])),
        body: TabBarView(children: [
          VendorProducts(
            vendorData: vendorData,
          ),
          VendorChats(),
        ]),
      ),
    );
  }
}
