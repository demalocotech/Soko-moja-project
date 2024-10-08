import 'package:flutter/material.dart';

showSnack(context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.lightGreen.shade900,
      content: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );
}
