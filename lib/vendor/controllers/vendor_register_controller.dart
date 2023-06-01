import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class vendorController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //FUNCTION TO STORE IMAGE IN FIREBASE STORAGE
  _uploadVendorImageToStorage(Uint8List? image) async {
    Reference ref =
        _storage.ref().child('storeimage').child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(image!);

    TaskSnapshot snapshot = await uploadTask;

    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  //FUNCTION TO STORE IMAGE IN FIREBASE STORAGE END

  //FUNCTION TO PICK STORE IMAGE
  pickstoreImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('no image selected');
    }
  }
  //FUNCTION TO PICK STORE IMAGE END

  //FUNCTION TO SAVE VENDORDATA

  Future<String> saveVendor(
    String businessName,
    String fullName,
    String email,
    String phoneNumber,
    String countryValue,
    String stateValue,
    String cityValue,
    String marketOptions,
    Uint8List? _image,
  ) async {
    String res = 'some error occured';
    try {
      String storeImage = await _uploadVendorImageToStorage(_image);

      //SAVE DATA TO CLOUD FIRESTORE
      _firestore.collection('vendors').doc(_auth.currentUser!.uid).set({
        'userId': _auth.currentUser!.uid,
        'businessName': businessName,
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'countryValue': countryValue,
        'stateValue': stateValue,
        'cityValue': cityValue,
        'marketOptions': marketOptions,
        'storeImage': storeImage,
        'createdat': Timestamp.now(),
        'approved': false,
      });
      ;
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
  //FUNCTION TO SAVE VENDORDATA END
}
