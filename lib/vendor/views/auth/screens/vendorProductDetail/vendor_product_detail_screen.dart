import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VendorProductDetailScreen extends StatefulWidget {
  final dynamic productData;

  const VendorProductDetailScreen({super.key, required this.productData});

  @override
  State<VendorProductDetailScreen> createState() =>
      _VendorProductDetailScreenState();
}

class _VendorProductDetailScreenState extends State<VendorProductDetailScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();
  final TextEditingController _categoryNameController = TextEditingController();
  @override
  void initState() {
    setState(() {
      _productNameController.text = widget.productData['productName'];
      _brandNameController.text = widget.productData['brandName'];
      _productPriceController.text =
          widget.productData['productPrice'].toString();
      _quantityController.text = widget.productData['quantity'].toString();
      _productDescriptionController.text =
          widget.productData['productDescription'];
      _categoryNameController.text = widget.productData['category'];
    });
    super.initState();
  }

  double? productPrice;
  int? quantity;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productData['productName']),
        backgroundColor: Colors.lightGreen.shade900,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _brandNameController,
                decoration: InputDecoration(labelText: 'Brand Name'),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: (value) {
                  productPrice = double.parse(value);
                },
                controller: _productPriceController,
                decoration: InputDecoration(labelText: 'Product Price'),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: (value) {
                  quantity = int.parse(value);
                },
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                maxLines: 3,
                maxLength: 250,
                controller: _productDescriptionController,
                decoration: InputDecoration(labelText: 'Product Description'),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _categoryNameController,
                enabled: false,
                decoration: InputDecoration(labelText: 'Category'),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(12.0),
        child: InkWell(
          onTap: () async {
            await _firestore
                .collection('products')
                .doc(widget.productData['productId'])
                .update({
              'productName': _productNameController.text,
              'brandName': _brandNameController.text,
              'productPrice': productPrice,
              'quantity': quantity,
              'productDescription': _productDescriptionController.text,
              'category': _categoryNameController.text,
            });
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.lightGreen.shade900,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'UPDATE PRODUCT',
                style: TextStyle(
                  letterSpacing: 6,
                  color: Colors.white,
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
