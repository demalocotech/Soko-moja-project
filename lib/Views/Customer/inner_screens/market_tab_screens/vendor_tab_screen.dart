import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sokomoja_project/Views/Customer/inner_screens/vendor_market_product_screens/chat_bubble.dart';
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
      height: MediaQuery.of(context).size.height,
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
                final vendorRatingsFuture = FirebaseFirestore.instance
                    .collection('ratings')
                    .where('vendorId', isEqualTo: vendorData.id)
                    .get();

                return FutureBuilder<QuerySnapshot>(
                  future: vendorRatingsFuture,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> ratingSnapshot) {
                    if (ratingSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: Colors.lightGreen.shade900,
                      ));
                    }

                    // Check if ratingSnapshot has data
                    if (!ratingSnapshot.hasData ||
                        ratingSnapshot.data!.docs.isEmpty) {
                      // Handle the case when there are no ratings for the vendor
                      // return Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   // ... existing code
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       // ... existing code
                      //       Text(
                      //         'No Ratings', // Display this when there are no ratings
                      //       ),
                      //       // ... existing code
                      //     ],
                      //   ),
                      // );
                    }

                    // Get rating data
                    final ratingData = ratingSnapshot.data!.docs;

                    // Calculate the average rating
                    double totalRating = 0.0;
                    ratingData.forEach((doc) {
                      totalRating += doc['rating'];
                    });
                    double averageRating = totalRating / ratingData.length;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
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
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Vendor Rating' +
                                        ' ' +
                                        averageRating.toStringAsFixed(2),
                                    style: TextStyle(
                                      color: Colors.lightGreen.shade900,
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
                          ExpansionTile(
                            title: Text(
                              'Comments For' + ' ' + vendorData['fullName'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            children: ratingData.map((doc) {
                              return ListTile(
                                title: ChatBubble(message: doc['comment']),
                              );
                            }).toList(),
                          ),
                          Divider(
                            color: Colors.lightGreen.shade500,
                            thickness: 10,
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            );
          }),
    ));
  }
}
