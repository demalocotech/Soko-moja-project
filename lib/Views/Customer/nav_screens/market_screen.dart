import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sokomoja_project/Views/Customer/inner_screens/all_products_screen.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _marketsStream =
        FirebaseFirestore.instance.collection('Markets').snapshots();

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.lightGreen.shade900,
        title: Text(
          'Markets',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _marketsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          return Container(
            height: 250,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final marketData = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: ListTile(
                    leading: Image.network(marketData['image']),
                    title: Text(marketData['marketName']),
                    onTap: () {},
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
