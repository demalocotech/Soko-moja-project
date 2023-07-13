import 'package:flutter/material.dart';
import 'package:sokomoja_project/Views/Customer/auth/login_screen.dart';
import 'package:sokomoja_project/vendor/views/auth/vendor_auth.dart';

class MainLandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen.shade500,
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.lightGreen.shade200,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'WELCOME TO SOKO MOJA',
                      style: TextStyle(
                        color: Colors.lightGreen.shade900,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Icon(
                        Icons.store,
                        size: 40,
                        color: Colors.lightGreen.shade900,
                      ),
                    ),
                    Text(
                      'Market Of Fresh Farm Products',
                      style: TextStyle(
                        color: Colors.lightGreen.shade900,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 200,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: ((context) {
                      return LoginScreen();
                    })));
                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.lightGreen.shade900,
                    ),
                    child: Center(
                      child: Text(
                        'CONTINUE AS CUSTOMER',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: ((context) {
                      return VendorAuthScreen();
                    })));
                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.lightGreen.shade900,
                    ),
                    child: Center(
                      child: Text(
                        'CONTINUE AS VENDOR',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
