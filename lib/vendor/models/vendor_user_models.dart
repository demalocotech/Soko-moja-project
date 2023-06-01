import 'package:cloud_firestore/cloud_firestore.dart';

//INSTRUCTIONS ON HOW EACH USER IS CREATED
class VendorUserModel {
  final bool? approved;

  final String? businessName;

  final String? cityValue;

  final String? countryValue;

  final Timestamp? createdat;

  final String? email;

  final String? fullName;

  final String? marketOptions;

  final String? phoneNumber;

  final String? stateValue;

  final String? storeImage;

  final String? userId;

  VendorUserModel(
      {required this.approved,
      required this.businessName,
      required this.cityValue,
      required this.countryValue,
      required this.createdat,
      required this.email,
      required this.fullName,
      required this.marketOptions,
      required this.phoneNumber,
      required this.stateValue,
      required this.storeImage,
      required this.userId});

  VendorUserModel.fromJson(Map<String, Object?> json)
      : this(
          approved: json['approved']! as bool,
          businessName: json['businessName']! as String,
          cityValue: json['cityValue']! as String,
          countryValue: json['countryValue']! as String,
          createdat: json['createdat']! as Timestamp,
          email: json['email']! as String,
          fullName: json['fullName']! as String,
          marketOptions: json['marketOptions']! as String,
          phoneNumber: json['phoneNumber']! as String,
          stateValue: json['stateValue']! as String,
          storeImage: json['storeImage']! as String,
          userId: json['userId']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'approved': approved,
      'businessName': businessName,
      'cityValue': cityValue,
      'countryValue': countryValue,
      'createdat': createdat,
      'email': email,
      'fullName': fullName,
      'marketOptions': marketOptions,
      'phoneNumber': phoneNumber,
      'stateValue': stateValue,
      'storeImage': storeImage,
      'userId': userId,
    };
  }
}
