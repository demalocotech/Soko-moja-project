import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:intl/intl.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';

class CustomerOrderScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String formatedDate(date) {
    final outPutDateFormat = DateFormat('dd/MM/yyyy');
    final outPutDate = outPutDateFormat.format(date);
    return outPutDate;
  }

  Future<dynamic> startTransaction(double amount, String phoneNumber) async {
    dynamic transactionInitialisation;
//Wrap it with a try-catch
    try {
//Run it
      transactionInitialisation =
          await MpesaFlutterPlugin.initializeMpesaSTKPush(
              businessShortCode:
                  "174379", //use your store number if the transaction type is CustomerBuyGoodsOnline
              transactionType: TransactionType
                  .CustomerPayBillOnline, //or CustomerBuyGoodsOnline for till numbers
              amount: amount,
              partyA: phoneNumber,
              partyB: "174379",
              callBackURL: Uri(
                  scheme: "https", host: "1234.1234.co.ke", path: "/1234.php"),
              accountReference: "payment",
              phoneNumber: phoneNumber,
              baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
              transactionDesc: "demo",
              passKey:
                  "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919");

      var result = transactionInitialisation as Map<String, dynamic>;
      if (result.keys.contains("ResponseCode")) {
        String mResponseCode = result['ResponseCode'];
        print('Resulting Code:' + mResponseCode);
        if (mResponseCode == '0') {
          // updateAccount(result['CheckoutRequestID']);
        }
      }

      print('RESULT:' + transactionInitialisation.toString());
    } catch (e) {
      print("Exception caught:" + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('customerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 5,
          ),
        ),
        backgroundColor: Colors.lightGreen.shade900,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.lightGreen.shade900,
              ),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return Slidable(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 14,
                            child: document['accepted'] == true
                                ? Icon(Icons.delivery_dining)
                                : Icon(
                                    Icons.access_time,
                                  ),
                          ),
                          title: document['accepted'] == true
                              ? Text(
                                  'Accepted',
                                  style: TextStyle(
                                    color: Colors.lightGreen.shade900,
                                  ),
                                )
                              : Text(
                                  'Not accepted',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                          trailing: Text(
                            'Amount' +
                                ' ' +
                                document['productPrice'].toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            formatedDate(
                              document['orderDate'].toDate(),
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        ExpansionTile(
                          title: Text(
                            'Other Details',
                            style: TextStyle(
                              color: Colors.lightGreen.shade900,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text('View Other Details'),
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                child: Image.network(
                                  document['productImage'][0],
                                ),
                              ),
                              title: Text(document['productName']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'Quantity',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        document['quantity'].toString(),
                                      ),
                                      Text(
                                        'Size',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        document['productSize'],
                                      ),
                                    ],
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Customers Details',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(document['firstName']),
                                        Text(
                                          document['email'],
                                        ),
                                        Text(document['phoneNumber']),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Divider(
                            thickness: 8,
                            color: Colors.lightGreen.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          await _firestore
                              .collection('orders')
                              .doc(document['orderId'])
                              .delete();
                        },
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          startTransaction(10.0, "254799097714");
                        },
                        backgroundColor: Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.thumb_up,
                        label: 'Pay',
                      ),
                    ],
                  ));
            }).toList(),
          );
        },
      ),
    );
  }
}
