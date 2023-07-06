import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:sokomoja_project/Views/Customer/auth/login_screen.dart';
import 'package:sokomoja_project/Views/Customer/main_screen.dart';
import 'package:sokomoja_project/Views/Customer/nav_screens/search_screen.dart';
import 'package:sokomoja_project/provider/cart_provider.dart';
import 'package:sokomoja_project/provider/product_provider.dart';
import 'package:sokomoja_project/vendor/views/auth/screens/main_vendor_screen.dart';
import 'package:sokomoja_project/vendor/views/auth/vendor_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) {
      return ProductProvider();
    }),
    ChangeNotifierProvider(create: (_) {
      return CartProvider();
    })
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Soko-Bold',
      ),
      home: LoginScreen(),
      builder: EasyLoading.init(),
    );
  }
}
