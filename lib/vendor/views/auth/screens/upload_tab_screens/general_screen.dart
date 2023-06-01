import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GeneralTabScreen extends StatefulWidget {
  @override
  State<GeneralTabScreen> createState() => _GeneralTabScreenState();
}

class _GeneralTabScreenState extends State<GeneralTabScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> _categoryList = [];

  _getCategories() {
    return _firestore
        .collection('categories')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _categoryList.add(doc['categoryName']);
        });
      });
    });
  }

  @override
  void initState() {
    _getCategories();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Enter Product Name'),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Enter Product Price'),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Enter Product Quantity'),
              ),
              SizedBox(
                height: 30,
              ),
              DropdownButtonFormField(
                  hint: Text('Select Category'),
                  items: _categoryList.map<DropdownMenuItem<String>>((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: ((value) {})),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                maxLines: 10,
                maxLength: 250,
                decoration: InputDecoration(
                  labelText: 'Enter Product Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
