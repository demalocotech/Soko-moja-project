import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:sokomoja_project/Views/Customer/inner_screens/edit_profile_screem.dart';
import 'package:sokomoja_project/Views/Customer/main_screen.dart';

import 'package:sokomoja_project/provider/cart_provider.dart';
import 'package:sokomoja_project/services/app_services.dart';
import 'package:uuid/uuid.dart';

class CheckOutScreen extends StatefulWidget {
  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  double rating = 0;
  String comment = '';
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    CollectionReference users =
        FirebaseFirestore.instance.collection('Customers');
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
          Map<String, dynamic> customerData =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              elevation: 1,
              backgroundColor: Colors.lightGreen.shade900,
              title: Text(
                'Checkout',
                style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 6,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: ListView.builder(
              shrinkWrap: true,
              itemCount: _cartProvider.getCartItem.length,
              itemBuilder: (BuildContext context, int index) {
                final cartData =
                    _cartProvider.getCartItem.values.toList()[index];

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    child: SizedBox(
                      height: 170,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.network(cartData.imageUrl[0]),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartData.productName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 5,
                                  ),
                                ),
                                Text(
                                  'KSH' +
                                      ' ' +
                                      cartData.productPrice.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 5,
                                    color: Colors.lightGreen.shade900,
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: null,
                                  child: Text(
                                    cartData.productSize,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            bottomSheet: customerData['email'] == ""
                ? TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: ((context) {
                        return EditProfileScreen(
                          userData: customerData,
                        );
                      }))).whenComplete(() {
                        Navigator.pop(context);
                      });
                    },
                    child: Text('enter email address'))
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: () {
                        //place order
                        if (rating != 0 && comment != '')
                          EasyLoading.show(status: 'placing order');

                        _cartProvider.getCartItem.forEach((key, item) {
                          showRatingDialog(context, item.userId);
                          final orderId = Uuid().v4();
                          if (rating != 0 && comment != '')
                            _fireStore.collection('orders').doc(orderId).set({
                              'payed': false,
                              'accepted': false,
                              'orderId': orderId,
                              'vendorId': item.userId,
                              'email': customerData['email'],
                              'phoneNumber': customerData['phoneNumber'],
                              'customerId': customerData['customerID'],
                              'firstName': customerData['firstName'],
                              'productName': item.productName,
                              'productPrice': item.productPrice,
                              'productId': item.productId,
                              'quantity': item.quantity,
                              'total': _cartProvider.totalPrice,
                              'productSize': item.productSize,
                              'productImage': item.imageUrl,
                              'orderDate': DateTime.now(),
                            }).whenComplete(() {
                              setState(() {
                                _cartProvider.getCartItem.clear();
                              });
                              AppService.generateReport(
                                  title: 'ORDER PLACED REPORT',
                                  content:
                                      'The order $orderId placed by ${customerData['firstName']} for ${item.quantity} ${item.productName} from vendor with id ${item.userId} wasplaced on ${DateTime.now()}');
                              EasyLoading.dismiss();
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: ((context) {
                                return MainScreen();
                              })));
                            });
                        });
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.lightGreen.shade900,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'PLACE ORDER',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 6,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          );
        }

        return Center(
          child: CircularProgressIndicator(
            color: Colors.lightGreen.shade900,
          ),
        );
      },
    );
  }

  void showRatingDialog(BuildContext context, String userId) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rate Your Vendor'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 30,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.lightGreen.shade900,
                ),
                onRatingUpdate: (newRating) {
                  rating = newRating;
                },
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  comment = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your comment...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.lightGreen.shade900,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Colors.lightGreen.shade900,
                ),
              ),
              onPressed: () async {
                String ratingId = Uuid().v4();
                await _firestore.collection('ratings').doc(ratingId).set({
                  'ratingId': ratingId,
                  'rating': rating,
                  'comment': comment,
                  'customerId': _auth.currentUser!.uid,
                  'vendorId': userId,
                  'createdAt': Timestamp.now(),
                }).whenComplete(() {
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }
}
