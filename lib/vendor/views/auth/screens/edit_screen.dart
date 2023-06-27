import 'package:flutter/material.dart';
import 'package:sokomoja_project/vendor/views/auth/screens/edit_product_tabs/published_product_tab.dart';
import 'package:sokomoja_project/vendor/views/auth/screens/edit_product_tabs/unpublished_product_tab.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 1,
          title: Text(
            'Manage Products',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: 7,
            ),
          ),
          backgroundColor: Colors.lightGreen.shade900,
          bottom: TabBar(tabs: [
            Tab(
              text: 'Published',
            ),
            Tab(
              text: 'Unpublished',
            ),
          ]),
        ),
        body: TabBarView(children: [
          PublishedProductTab(),
          UnpublishedProductTab(),
        ]),
      ),
    );
  }
}
