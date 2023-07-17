import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../services/app_services.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  _uploadProfileImageToStorage(Uint8List image) async {
    Reference ref =
        _storage.ref().child('profilepics').child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(image);

    TaskSnapshot snapShot = await uploadTask;

    String downloadUrl = await snapShot.ref.getDownloadURL();
    return downloadUrl;
  }

  pickProfileImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('No image selected');
    }
  }

  Future<String> signUpUsers(String firstName, String lastName, String email,
      String phoneNumber, String password, Uint8List? image) async {
    String res = 'some error occured';

    try {
      if (firstName.isNotEmpty &&
          lastName.isNotEmpty &&
          email.isNotEmpty &&
          phoneNumber.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        //create the users
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String profileImageUrl = await _uploadProfileImageToStorage(image);

        await _firestore.collection('Customers').doc(cred.user!.uid).set({
          'customerID': cred.user!.uid,
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'phoneNumber': phoneNumber,
          'createdAt': Timestamp.now(),
          'profileImage': profileImageUrl,
        });
        AppService.generateReport(
            title: 'SIGN UP REPORT',
            content:
                'The user (customer) with Id:${cred.user!.uid} ,$firstName $lastName signed up for an account on the app on ${timestamp.toString()}');

        res = 'success';
      } else {
        res = 'Field cannot be empty!';
      }
    } catch (e) {}
    return res;
  }

  loginUsers(String email, String password) async {
    String res = 'something went wrong';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        AppService.generateReport(
            title: 'LOG IN REPORT',
            content:
                'The user(customer) with Id:${FirebaseAuth.instance.currentUser!.uid} bearing email:$email logged into the app on ${timestamp.toString()}');
        res = 'success';
      } else {
        res = 'fields must not be empty';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
