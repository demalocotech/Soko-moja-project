import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

final DateTime timestamp = DateTime.now();
final reportRef = FirebaseFirestore.instance.collection('reports');

class AppService {
  static int generateRandomFirebaseId() {
    Random rand = Random();
    var docId = rand.nextInt(700000000);
    return docId;
  }

  static void generateReport({required String title, required String content}) {
    var docIdString = generateRandomFirebaseId();
    var docFinalId =
        timestamp.toString().split(" ")[0] + docIdString.toString();

    reportRef.doc(docFinalId).set({
      "reportTitle": title,
      "reportContent": content,
      "date": timestamp.toString().split(" ")[0]
    })
        // .onError((error, stackTrace) => showToastMessage(error.toString()))
        ;
  }
  //  static void showToastMessage(String message){
  //   Fluttertoast.showToast(
  //       msg: message,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0
  //   );
  // }

  static void showDialog(String message, {required BuildContext context}) {
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //
    //     builder: (BuildContext context){
    //       return ProgressAlert(message: 'Authenticating ,Please wait...');
    //     });
  }
}
