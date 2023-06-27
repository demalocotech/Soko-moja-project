import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InfoTabScreen extends StatelessWidget {
  final marketData;

  const InfoTabScreen({super.key, required this.marketData});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.lightGreen.shade900,
            ),
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              marketData['image'],
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Divider(
            color: Colors.lightGreen.shade900,
          ),
        ),
        Text(
          'Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.lightGreen.shade900,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                marketData['marketDescription'],
                style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
