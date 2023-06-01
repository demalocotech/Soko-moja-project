import 'package:flutter/material.dart';
import 'package:sokomoja_project/vendor/views/auth/screens/upload_tab_screens/attributes_tab_screen.dart';
import 'package:sokomoja_project/vendor/views/auth/screens/upload_tab_screens/general_screen.dart';
import 'package:sokomoja_project/vendor/views/auth/screens/upload_tab_screens/images_tab_screen.dart';
import 'package:sokomoja_project/vendor/views/auth/screens/upload_tab_screens/shipping_tab_screen.dart';

class VendorUploadScreen extends StatelessWidget {
  const VendorUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen.shade900,
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text('General'),
              ),
              Tab(
                child: Text('shipping'),
              ),
              Tab(
                child: Text('attributes'),
              ),
              Tab(
                child: Text('images'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GeneralTabScreen(),
            ShippingTabScreen(),
            AttributeTabScreen(),
            ImagesTabScreen(),
          ],
        ),
      ),
    );
  }
}
