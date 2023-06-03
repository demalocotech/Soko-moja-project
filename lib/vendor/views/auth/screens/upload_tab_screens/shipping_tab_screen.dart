import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sokomoja_project/provider/product_provider.dart';

class ShippingTabScreen extends StatefulWidget {
  const ShippingTabScreen({super.key});

  @override
  State<ShippingTabScreen> createState() => _ShippingTabScreenState();
}

class _ShippingTabScreenState extends State<ShippingTabScreen> {
  bool? _chargeDelivery = false;
  late int _deliveryCharge;

  @override
  Widget build(BuildContext context) {
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return Column(
      children: [
        CheckboxListTile(
          title: Text(
            'Charge Delivery',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
          ),
          value: _chargeDelivery,
          onChanged: ((value) {
            setState(() {
              _chargeDelivery = value;
              _productProvider.getFormData(chargeDelivery: _chargeDelivery);
            });
          }),
        ),
        if (_chargeDelivery == true)
          TextFormField(
            onChanged: (value) {
              _deliveryCharge = int.parse(value);
              _productProvider.getFormData(deliveryCharge: _deliveryCharge);
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Delivery Charge',
            ),
          ),
      ],
    );
  }
}
