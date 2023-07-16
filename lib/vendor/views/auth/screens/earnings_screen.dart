import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sokomoja_project/Views/Customer/inner_screens/vendor_market_product_screens/chat_bubble.dart';
import 'package:sokomoja_project/vendor/views/auth/screens/inner_screen/chat_homepage.dart';
import 'package:sokomoja_project/vendor/views/auth/screens/inner_screen/chat_screen.dart';
import 'package:sokomoja_project/vendor/views/auth/screens/vendor_inner_screen/vendor_withdrawal_screen.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ratingsStream = FirebaseFirestore.instance
        .collection('ratings')
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    CollectionReference users =
        FirebaseFirestore.instance.collection('vendors');
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              appBar: AppBar(
                elevation: 1,
                backgroundColor: Colors.lightGreen.shade900,
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(data['storeImage']),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Hi' + ' ' + data['businessName'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          letterSpacing: 4,
                        ),
                      ),
                    )
                  ],
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: ((context) {
                          return ChatHomePage();
                        })));
                      },
                      icon: Icon(Icons.chat_bubble)),
                ],
              ),
              body: StreamBuilder<QuerySnapshot>(
                stream: _ordersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  //logic to get total orders price
                  double totalOrders = 0.0;
                  for (var orderItem in snapshot.data!.docs) {
                    totalOrders +=
                        orderItem['quantity'] * orderItem['productPrice'];
                  }

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                              color: Colors.lightGreen.shade900,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    'TOTAL EARNINGS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    'KSH' +
                                        ' ' +
                                        totalOrders.toStringAsFixed(2),
                                    style: TextStyle(
                                      color: Colors.yellow.shade900,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                              color: Colors.lightGreen.shade900,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    'TOTAL ORDERS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: TextStyle(
                                      color: Colors.yellow.shade900,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: ((context) {
                                return VendorWithdrawalScreen();
                              })));
                            },
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width - 40,
                              decoration: BoxDecoration(
                                color: Colors.lightGreen.shade900,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Withdraw',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 6,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: _ratingsStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Something went wrong');
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text("Loading");
                                }

                                final ratingData = snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                  return document.data()!
                                      as Map<String, dynamic>;
                                }).toList();

                                double totalRating = 0.0;

                                if (ratingData.isNotEmpty) {
                                  ratingData.forEach((doc) {
                                    totalRating += doc['rating'];
                                  });
                                }

                                double averageRating = (ratingData.isNotEmpty)
                                    ? totalRating / ratingData.length
                                    : 0.0;

                                return ListView.builder(
                                  itemCount: ratingData.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final rating = ratingData[index];

                                    return ListTile(
                                      title: Text('Rating' +
                                              ' ' +
                                              rating['rating'].toString() ??
                                          ''),
                                      subtitle: Text('Your Total Ratings:' +
                                              ' ' +
                                              ratingData.length.toString() +
                                              ' ' +
                                              'average:' +
                                              ' ' +
                                              averageRating
                                                  .toStringAsFixed(2) ??
                                          ''),
                                      trailing: ChatBubble(
                                        message: rating['comment'],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(
              color: Colors.lightGreen.shade900,
            ),
          );
        });
  }
}
