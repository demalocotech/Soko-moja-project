import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sokomoja_project/Views/Customer/product_Detail/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchedValue = '';

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream =
        FirebaseFirestore.instance.collection('products').snapshots();

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.lightGreen.shade900,
          ),
          backgroundColor: Colors.lightGreen.shade900,
          title: TextFormField(
            onChanged: (value) {
              setState(() {
                _searchedValue = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'search for products',
              labelStyle: TextStyle(
                color: Colors.white,
                letterSpacing: 4,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: _searchedValue == ''
            ? Center(
                child: Text(
                  'Search For Products',
                  style: TextStyle(
                    fontSize: 25,
                    letterSpacing: 5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : StreamBuilder<QuerySnapshot>(
                stream: _productsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  final searchedData = snapshot.data!.docs.where((element) {
                    return element['productName']
                        .toLowerCase()
                        .contains(_searchedValue.toLowerCase());
                  });
                  return SingleChildScrollView(
                    child: Column(
                      children: searchedData.map((e) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: ((context) {
                              return productDetailScreen(productData: e);
                            })));
                          },
                          child: Card(
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Image.network(e['imageUrls'][0]),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      e['productName'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      e['productPrice'].toStringAsFixed(2),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.lightGreen.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }));
  }
}
