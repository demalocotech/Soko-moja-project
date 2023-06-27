import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sokomoja_project/Views/Customer/inner_screens/vendor_market_product_screens/vendor_product_chat.dart';

class VendorTabScreen extends StatelessWidget {
  final marketData;

  const VendorTabScreen({super.key, required this.marketData});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
        .collection('vendors')
        .where('marketOptions', isEqualTo: marketData['marketName'])
        .snapshots();
    return Scaffold(
      body: Container(
        height: 300,
        child: StreamBuilder<QuerySnapshot>(
          stream: _productStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.lightGreen.shade900,
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final vendorData = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.lightGreen.shade900,
                          radius: 30,
                          child: vendorData['storeImage'] == null
                              ? Icon(
                                  CupertinoIcons.person,
                                )
                              : Image.network(
                                  vendorData['storeImage'],
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            vendorData['fullName'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 5,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            vendorData['businessName'],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w200,
                              letterSpacing: 5,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightGreen.shade900,
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return VendorProductChat(
                              vendorData: vendorData,
                            );
                          }));
                        },
                        child: Text(
                          'view',
                          style: TextStyle(
                            letterSpacing: 5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
