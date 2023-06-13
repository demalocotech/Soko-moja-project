import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:sokomoja_project/provider/product_provider.dart';
import 'package:sokomoja_project/vendor/views/auth/screens/main_vendor_screen.dart';
import 'package:sokomoja_project/vendor/views/auth/screens/upload_tab_screens/attributes_tab_screen.dart';
import 'package:sokomoja_project/vendor/views/auth/screens/upload_tab_screens/general_tabs_screen.dart';
import 'package:sokomoja_project/vendor/views/auth/screens/upload_tab_screens/images_tab_screen.dart';
import 'package:sokomoja_project/vendor/views/auth/screens/upload_tab_screens/shipping_tab_screen.dart';
import 'package:uuid/uuid.dart';

class VendorUploadScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return DefaultTabController(
      length: 4,
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightGreen.shade900,
            elevation: 0,
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text('General'),
                ),
                Tab(
                  child: Text('shipping'),
                ),
                Tab(
                  child: Text('attributes'),
                ),
                Tab(
                  child: Text('images'),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              GeneralTabScreen(),
              ShippingTabScreen(),
              AttributeTabScreen(),
              ImagesTabScreen(),
            ],
          ),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.lightGreen.shade900,
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final productId = Uuid().v4();
                  EasyLoading.show(status: 'uploading product');
                  await _firestore.collection('products').doc(productId).set({
                    'productId': productId,
                    'productName': _productProvider.productData['productName'],
                    'productPrice':
                        _productProvider.productData['productPrice'],
                    'quantity': _productProvider.productData['quantity'],
                    'category': _productProvider.productData['category'],
                    'productDescription':
                        _productProvider.productData['productDescription'],
                    'imageUrls': _productProvider.productData['imageUrls'],
                    'chargeDelivery':
                        _productProvider.productData['chargeDelivery'],
                    'deliveryCharge':
                        _productProvider.productData['deliveryCharge'],
                    'brandName': _productProvider.productData['brandName'],
                    'sizeList': _productProvider.productData['sizeList'],
                    'addedAt': Timestamp.now(),
                    'UserId': FirebaseAuth.instance.currentUser!.uid,
                  }).whenComplete(() {
                    _productProvider.clearData();
                    _formKey.currentState!.reset();

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return MainVendorScreen();
                    }));
                  });
                  EasyLoading.dismiss();
                }
              },
              child: Text('save'),
            ),
          ),
        ),
      ),
    );
  }
}
