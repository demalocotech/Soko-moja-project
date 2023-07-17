import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:sokomoja_project/services/app_services.dart';

class VendorOrderScreen extends StatelessWidget {
  String formatedDate(date) {
    final outPutDateFormat = DateFormat('dd/MM/yyyy');
    final outPutDate = outPutDateFormat.format(date);
    return outPutDate;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                                      'Buyer Details',
                                      style: TextStyle(
                                        fontSize: 18,
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
                              .update({
                            'accepted': false,
                          });
                        },
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Reject',
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          await _firestore
                              .collection('orders')
                              .doc(document['orderId'])
                              .update({
                            'accepted': true,
                          });
                          AppService.generateReport(
                              title: 'ORDER ACCEPTED REPORT',
                              content:
                                  'The order ${document['orderId']} placed by ${document['firstName']} for  from vendor with id ${FirebaseAuth.instance.currentUser!.uid} was accepted on ${DateTime.now()}');
                        },
                        backgroundColor: Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.thumb_up,
                        label: 'Accept',
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
