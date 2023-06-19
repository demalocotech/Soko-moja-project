import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EditProfileScreen extends StatefulWidget {
  final dynamic userData;

  EditProfileScreen({super.key, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    setState(() {
      _firstNameController.text = widget.userData['firstName'];
      _lastNameController.text = widget.userData['lastName'];
      _emailController.text = widget.userData['email'];
      _phoneNumberController.text = widget.userData['phoneNumber'];
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen.shade900,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            letterSpacing: 6,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.lightGreen.shade900,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          CupertinoIcons.photo,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'Enter First Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Enter Last Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'email',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Enter Phone Number',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(13.0),
        child: InkWell(
          onTap: () async {
            EasyLoading.show(status: 'Updating');
            await _firestore
                .collection('Customers')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({
              'firstName': _firstNameController.text,
              'lastName': _lastNameController.text,
              'phoneNumber': _phoneNumberController.text,
            }).whenComplete(() {
              EasyLoading.dismiss();
              Navigator.pop(context);
            });
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.lightGreen.shade900,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'UPDATE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  letterSpacing: 6,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
