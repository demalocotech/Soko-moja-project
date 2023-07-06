import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:sokomoja_project/Views/Customer/inner_screens/market_tab_screens/info_tab_screen.dart';
import 'package:sokomoja_project/Views/Customer/inner_screens/market_tab_screens/vendor_tab_screen.dart';

class VendorProductScreen extends StatelessWidget {
  final String marketId;

  const VendorProductScreen({super.key, required this.marketId});

  @override
  Widget build(BuildContext context) {
    CollectionReference marketData =
        FirebaseFirestore.instance.collection('markets');

    return FutureBuilder<DocumentSnapshot>(
      future: marketData.doc(marketId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> marketData =
              snapshot.data!.data() as Map<String, dynamic>;
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.lightGreen.shade900,
                elevation: 1,
                bottom: TabBar(tabs: [
                  Tab(
                    child: Text('Info'),
                  ),
                  Tab(
                    child: Text('Vendors'),
                  ),
                ]),
              ),
              body: TabBarView(children: [
                InfoTabScreen(
                  marketData: marketData,
                ),
                VendorTabScreen(
                  marketData: marketData,
                ),
              ]),
            ),
          );
        }

        return Text("loading");
      },
    );
  }
}
