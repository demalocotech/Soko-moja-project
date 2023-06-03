import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sokomoja_project/provider/product_provider.dart';

class AttributeTabScreen extends StatefulWidget {
  @override
  State<AttributeTabScreen> createState() => _AttributeTabScreenState();
}

class _AttributeTabScreenState extends State<AttributeTabScreen> {
  final TextEditingController _sizeController = TextEditingController();

  String? _brandName;

  bool _entered = false;

  List<String> _sizeList = [];

  @override
  Widget build(BuildContext context) {
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          TextFormField(
            onChanged: (value) {
              _brandName = value;
              _productProvider.getFormData(brandName: _brandName);
            },
            decoration: InputDecoration(
              label: Text('brand'),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Container(
                  width: 100,
                  child: TextFormField(
                    controller: _sizeController,
                    onChanged: (value) {
                      setState(() {
                        _entered = true;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Size',
                    ),
                  ),
                ),
              ),
              _entered == true
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightGreen.shade900,
                      ),
                      onPressed: () {
                        setState(() {
                          _sizeList.add(_sizeController.text);
                        });
                        print(_sizeList);
                      },
                      child: Text('Add'),
                    )
                  : Text(''),
            ],
          ),
        ],
      ),
    );
  }
}
