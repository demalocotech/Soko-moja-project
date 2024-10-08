import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class VendorWithdrawalScreen extends StatelessWidget {
  late String amount;
  late String name;
  late String mobileNumber;
  late String providerName;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen.shade900,
        elevation: 1,
        title: Text(
          'Withdraw',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 6,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  onChanged: (value) {
                    amount = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Amount';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Your Phone Number';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    mobileNumber = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Phone Number', hintText: '+254...'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Your Provider Name';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    providerName = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Name of Provider',
                      hintText: 'Safaricom, Airtel etc.'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Your Name';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    name = value;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String transactionId = Uuid().v4();

                      ///store data to db
                      await _firestore
                          .collection('withdrawal')
                          .doc(transactionId)
                          .set({
                        'amount': amount,
                        'phoneNumber': mobileNumber,
                        'providerName': providerName,
                        'name': name,
                        'transactionId': transactionId,
                      });

                      print('cool');
                    } else {
                      print('false');
                    }
                  },
                  child: Text(
                    'Get Cash',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.lightGreen.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
