import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/vendor_register_controller.dart';

class VendorRegistrationScreen extends StatefulWidget {
  @override
  State<VendorRegistrationScreen> createState() =>
      _VendorRegistrationScreenState();
}

class _VendorRegistrationScreenState extends State<VendorRegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final vendorController _vendorController = vendorController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String fullName;
  late String businessName;
  late String email;
  late String phoneNumber;
  late String countryValue;
  late String stateValue;
  late String cityValue;
  Uint8List? _image;
  final List<String> _marketList = [];

  selectGalleryImage() async {
    Uint8List im = await _vendorController.pickstoreImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  String? _marketStatus;

  List<String> _marketOptions = [
    'Nyeri',
    'Karatina',
    'Githurai',
  ];
  _saveVendorDetail() async {
    EasyLoading.show(status: 'please wait');
    if (_formKey.currentState!.validate()) {
      await _vendorController
          .saveVendor(businessName, fullName, email, phoneNumber, countryValue,
              stateValue, cityValue, _marketStatus!, _image)
          .whenComplete(() {
        EasyLoading.dismiss();
        setState(() {
          _formKey.currentState!.reset();
          _image = null;
        });
      });
    } else {
      print('bad');
      EasyLoading.dismiss();
    }
  }

  _getMarket() {
    return _firestore
        .collection('Markets')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _marketList.add(doc['marketName']);
        });
      });
    });
  }

  @override
  void initState() {
    _getMarket();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 200,
            flexibleSpace: LayoutBuilder(builder: (context, Constraints) {
              return FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.lightGreen,
                        Colors.lightGreen.shade900,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _image != null
                              ? Image.memory(_image!)
                              : IconButton(
                                  onPressed: () {
                                    selectGalleryImage();
                                  },
                                  icon: Icon(CupertinoIcons.photo),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        businessName = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter business name';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Business name',
                      ),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        fullName = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter full name';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Full name',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        email = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter email';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email adress',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        phoneNumber = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter phone number';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Phone number',
                      ),
                    ),
                    SelectState(
                      onCountryChanged: (value) {
                        setState(() {
                          countryValue = value;
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          stateValue = value;
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          cityValue = value;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'select your market',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            child: Container(
                              width: 150,
                              child: DropdownButtonFormField(
                                  hint: Text('select'),
                                  items: _marketList
                                      .map<DropdownMenuItem<String>>((e) {
                                    return DropdownMenuItem(
                                        value: e, child: Text(e));
                                  }).toList(),
                                  onChanged: (value) {
                                    _marketStatus = value;
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        _saveVendorDetail();
                      },
                      child: Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width - 40,
                        decoration: BoxDecoration(
                          color: Colors.lightGreen.shade900,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
